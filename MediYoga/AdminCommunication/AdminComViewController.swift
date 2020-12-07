//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit
import AVFoundation
import Firebase
import SDWebImage

struct MessageDataAdmin {
    var text : String
    var time : String
    var isFirstUser : Bool
    var sendimagebool : Bool
    var sentimage : UIImage?
    var sentlabel:String
    var url:String
    var ReceiverImageBool: Bool
    var doctoraudio: Bool
    var patientaudio: Bool
    var DoctorRecordLabel: String
    var date:Date

}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: "\(day)/\(month)/\(year)") ?? Date()
    }
}


class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,AminDoctorImage,AminImage{
    var message = [MessageDataAdmin]()
    var SectionHeaderDate = [String]()
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var dateupdate: String?
    var timeupdate: String?
    var GroupImage:String = ""
    var GroupName:String = ""
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var meterTimer: Timer!
    var soundFileURL: URL!
    let db = Firestore.firestore()
    var Doctor_ID:String = ""
    var Admin_ID:String = ""
    var documentID: String = ""
    var DoctorName: String = ""
    var SelectedImages:String = ""
    var Image_url:String?
    var orderdate = String()
    
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SelectedImage: UIImageView!
    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var View_Chat_Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    
    
    var ChatMessage = [[MessageDataAdmin]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        print("Doctor_ID : \(Doctor_ID) , Admin_ID : \(Admin_ID)")
        View_Chat_Image.layer.cornerRadius = 23
        View_Chat_Image.clipsToBounds = true
        self.picker.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        ChatTextField.layer.cornerRadius = 13.0
        ChatTextField.layer.borderWidth = 1.0
        ChatTextField.layer.borderColor = UIColor.systemGray5.cgColor
        View_Chat_Image.image = UIImage(named: GroupImage)
        View_Chat_Name.text = GroupName
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        ActivityIndicator.startAnimating()
        tableView.register(UINib(nibName: "DoctorImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorImageTableViewCell")

        tableView.register(UINib(nibName: "AdminTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminTextTableViewCell")
        

        tableView.register(UINib(nibName: "AdminComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminImageCell")
        
        tableView.register(UINib(nibName:"AdminAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminAudioTableViewCell")
        
        tableView.register(UINib(nibName: "DoctorAudioTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorAudioTableViewCell")
        messages()
        tableView.rowHeight = UITableView.automaticDimension

    }
    
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    
    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.buttomconstrains.constant = keyBoardHeight

                var contentInset:UIEdgeInsets = self.tableView.contentInset

                self.tableView.contentInset = contentInset
                if message.count != 0{
                    tableView.scrollToRow(at: IndexPath(row: message.count-1 , section: ChatMessage.count-1), at: .top, animated: true)
                }
                contentInset.bottom = keyBoardRect!.height
                let indexpath = NSIndexPath(row: 1, section: 0)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    @objc func keyBoardWillHide(notification: Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset

        self.buttomconstrains.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .tertiarySystemFill
            textColor = .black
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = ChatMessage[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            print("dateString : \(dateString)")
            let label = DateHeaderLabel()
            label.text = dateString
            
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
            
        }
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return ChatMessage.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessage[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if ChatMessage.count != 0 {
            ActivityIndicator.stopAnimating()
        }
        if ChatMessage[indexPath.section][indexPath.row].isFirstUser == false && ChatMessage[indexPath.section][indexPath.row].ReceiverImageBool == false{
            
            let AdminTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminTextTableViewCell", for: indexPath) as! AdminTextTableViewCell

            AdminTextTableViewCell.AdmintextView.layer.cornerRadius = 16
            AdminTextTableViewCell.AdminText.text = ChatMessage[indexPath.section][indexPath.row].text
            print(ChatMessage[indexPath.section][indexPath.row].text)
            AdminTextTableViewCell.ReadCheck.text = "unread"
            AdminTextTableViewCell.Admintime.text = ChatMessage[indexPath.section][indexPath.row].time
            
            return AdminTextTableViewCell
        }
        else if ChatMessage[indexPath.section][indexPath.row].sendimagebool == false && ChatMessage[indexPath.section][indexPath.row].ReceiverImageBool == true{
         if ChatMessage[indexPath.section][indexPath.row].sentimage != nil{
                let AdminComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminImageCell", for: indexPath) as! AdminComImageTableViewCell
            AdminComImageTableViewCell.AdminImage_View.layer.cornerRadius = 10
            AdminComImageTableViewCell.AdminImage_View.clipsToBounds = true
            AdminComImageTableViewCell.ChatImage.layer.cornerRadius = 10
            AdminComImageTableViewCell.ChatImage.clipsToBounds = true
            AdminComImageTableViewCell.CellDelegate = self
            AdminComImageTableViewCell.index = indexPath

            AdminComImageTableViewCell.ChatImage.image = ChatMessage[indexPath.section][indexPath.row].sentimage
            if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = true
            }else{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = false
                AdminComImageTableViewCell.AdminChatLabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
            }
            return AdminComImageTableViewCell
        }}else if ChatMessage[indexPath.section][indexPath.row].sendimagebool == true && ChatMessage[indexPath.section][indexPath.row].isFirstUser == true{
            if ChatMessage[indexPath.section][indexPath.row].sentimage != nil{
                   let DoctorImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DoctorImageTableViewCell", for: indexPath) as! DoctorImageTableViewCell
                DoctorImageTableViewCell.DoctorImageView.layer.cornerRadius = 10
                DoctorImageTableViewCell.DoctorImageView.clipsToBounds = true
                DoctorImageTableViewCell.DoctorView.layer.cornerRadius = 10
                DoctorImageTableViewCell.DoctorView.clipsToBounds = true
                DoctorImageTableViewCell.CellDelegate = self
                DoctorImageTableViewCell.index = indexPath

                DoctorImageTableViewCell.DoctorImageView.image = ChatMessage[indexPath.section][indexPath.row].sentimage
               if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                DoctorImageTableViewCell.DoctorLabel.isHidden = true
               }else{
                DoctorImageTableViewCell.DoctorLabel.isHidden = false
                DoctorImageTableViewCell.DoctorLabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
               }
               return DoctorImageTableViewCell
            }else{
            let DoctorImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DoctorImageTableViewCell", for: indexPath) as! DoctorImageTableViewCell
            DoctorImageTableViewCell.DoctorImageView.layer.cornerRadius = 10
            DoctorImageTableViewCell.DoctorImageView.clipsToBounds = true
            DoctorImageTableViewCell.DoctorView.layer.cornerRadius = 10
            DoctorImageTableViewCell.DoctorView.clipsToBounds = true
            DoctorImageTableViewCell.CellDelegate = self
            DoctorImageTableViewCell.index = indexPath

            let storageref = Storage.storage().reference(forURL: ChatMessage[indexPath.section][indexPath.row].url)
            
            let fetchref = storageref.getData(maxSize: 1*1024*1024)
            { data, error in
                if error != nil {
                    print("image Upload Error - DoctorImageTableViewCell")
             } else {
                DispatchQueue.global(qos: .background).async {
                    let url = URL(string:(self.ChatMessage[indexPath.section][indexPath.row].url))
                    let data = try? Data(contentsOf: url!)
                    let image: UIImage = UIImage(data: data!)!
                    DispatchQueue.main.async {
//                        self.imageCache.setObject(image, forKey: NSString(string: (activeUser?.login!)!))
                        DoctorImageTableViewCell.DoctorImageView.image = image
//                        cell.imgFollow.image = image
                    }
                }
//                    DoctorImageTableViewCell.DoctorImageView.image = UIImage(data: data!)
             }
            }
            if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                DoctorImageTableViewCell.DoctorLabel.isHidden = true
            }else{
                DoctorImageTableViewCell.DoctorLabel.isHidden = false
                DoctorImageTableViewCell.DoctorLabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
            }
            return DoctorImageTableViewCell
            }
        }else if ChatMessage[indexPath.section][indexPath.row].ReceiverImageBool == true && ChatMessage[indexPath.section][indexPath.row].isFirstUser == false{
            let AdminComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminComImageTableViewCell", for: indexPath) as! AdminComImageTableViewCell
            AdminComImageTableViewCell.AdminImage_View.layer.cornerRadius = 10
            AdminComImageTableViewCell.AdminImage_View.clipsToBounds = true
            AdminComImageTableViewCell.ChatImage.layer.cornerRadius = 10
            AdminComImageTableViewCell.ChatImage.clipsToBounds = true
            AdminComImageTableViewCell.CellDelegate = self
            AdminComImageTableViewCell.index = indexPath

            let storageref = Storage.storage().reference(forURL: ChatMessage[indexPath.section][indexPath.row].url)
            
            let fetchref = storageref.getData(maxSize: 1*1024*1024)
            { [self] data, error in
                if error != nil {
                    print("image Upload Error")
             } else {
                
                AdminComImageTableViewCell.imageView?.sd_setImage(with: URL(string: ChatMessage[indexPath.section][indexPath.row].url),placeholderImage: UIImage(named: "Loading"),options: [.continueInBackground,.progressiveLoad])

//                AdminComImageTableViewCell.ChatImage.image = UIImage(data: data!)
             }
            }
            if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = true
            }else{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = false
                AdminComImageTableViewCell.AdminChatLabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
            }
            return AdminComImageTableViewCell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminComTableViewCell

            cell.Chat_View.layer.cornerRadius = 16
            cell.ChatLabel.text = ChatMessage[indexPath.section][indexPath.row].text
                   cell.ReadCheck.text = "unread"
            cell.ChatTime.text = ChatMessage[indexPath.section][indexPath.row].time
            
            return cell
}
return UITableViewCell()

    }
    
    
    @IBAction func CameraAct(_ sender: Any) {
        
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        present(picker,animated: true,completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        date()
        time()
        
        if let images = info[UIImagePickerController.InfoKey.originalImage] {
            
            SelectedImage.image = images as! UIImage
            message.append(MessageDataAdmin(text: ChatTextField.text!, time: timeupdate!, isFirstUser: true, sendimagebool: true, sentimage: images as? UIImage , sentlabel: ChatTextField.text!, url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false,DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(dateupdate)")))

                let randomid = UUID.init().uuidString
                let uploadref = Storage.storage().reference(withPath: "chat/euO4eHLyxXKDVmLCpNsO/\(randomid).jpg")
            guard let imagedata = self.SelectedImage?.image?.jpegData(compressionQuality: 0.3) else {
                    return
                }
                let uploadMetadata = StorageMetadata.init()
                uploadref.putData(imagedata, metadata: uploadMetadata){(downloadMetaData,error) in
                    if error != nil{
                        print("error path meta uploaddata 1\(error?.localizedDescription)")
                    return
                    }
                    print("\(String(describing: downloadMetaData))")

                    uploadref.downloadURL(completion:  { [self] (url,error) in
                        if error != nil
                        {
                            print("doewloadurl error msg \(error?.localizedDescription)")
                            return
                        }
                        if url != nil {
                            let url = url!.absoluteString
                            db.collection("internal_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": Doctor_ID,"sender_name": DoctorName,"text": "image","time_stamp": FieldValue.serverTimestamp(),"type": 1,"content_url": url])
                        }
                })
                }
            
            
            
            ChatTextField.text = ""
            tableView.reloadData()

                } else {
                    print("Check Image Code Error...!!!")
                }
                
                self.dismiss(animated: true, completion: nil)
         }

    
    @IBAction func BackSegue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Miceact(_ sender: Any) {
    }
    
    @IBAction func CallAct(_ sender: UIButton) {
        if let phoneURL = URL(string: "tel://9003660005"){
            if application.canOpenURL(phoneURL){
                application.open(phoneURL,options: [:],completionHandler: nil)
            }
        }

    }
   
    func date(){
        let currentDateTime = Date()

        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        dateupdate = formatter.string(from: currentDateTime)
        
    }

    func time(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        timeupdate = formatter.string(from: currentDateTime)
 
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        date()
        time()
        let textFromField:String = ChatTextField.text!
        if ChatTextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "", message: "Message TextField Empty", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )

        }
        else{
            
            db.collection("internal_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": Doctor_ID,"sender_name": DoctorName,"text": textFromField,"time_stamp": FieldValue.serverTimestamp(),"type": 0])
            let newDocument = db.collection("internal_chat").document(documentID)
            newDocument.updateData(["last_message": textFromField,"last_message_time": FieldValue.serverTimestamp()])

            
            message.append(MessageDataAdmin(text: textFromField,time: timeupdate!,isFirstUser: true, sendimagebool: false, sentlabel: "",url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false,DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(dateupdate)")))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: message.count - 1, section: 1)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 1), at: .top, animated: true)
            ChatTextField.text = ""
            
        }
        
       return true
        tableView.reloadData()
        
    }


    func messages(){

        db.collection("internal_chat").document(documentID).collection("messages").order(by: "time_stamp").getDocuments(){ [self] (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {

                  let docId = document.documentID
                  let documentData = document.data()
                  let time_Stamp = documentData["time_stamp"] as! Timestamp
                  let timeStamp = time_Stamp.dateValue()
                  let dateFormatter = DateFormatter()
                  dateFormatter.amSymbol = "AM"
                  dateFormatter.pmSymbol = "PM"
                  dateFormatter.dateFormat = "hh:mm a"
                  let ChatTime = dateFormatter.string(from: timeStamp)
                  let sender_id = documentData["sender_id"] as! String
                    let headerdate = DateFormatter()
                    headerdate.dateFormat = "dd MMMM yyyy"
                    let ChatDate = headerdate.string(from: timeStamp)
                    SectionHeaderDate.append(ChatDate)
                    print("ChatDate : \(ChatDate)")

                    if Doctor_ID == sender_id {
                        if documentData["type"] as! Int == 0{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(ChatDate)")))
                            print("1. \(documentData["text"] as! String) 2. \(ChatDate)")

                        }
                        else if documentData["type"] as! Int == 1{
                            print("2. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: true, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(ChatDate)")))


                        }

                        else if documentData["type"] as! Int == 3{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: true,patientaudio: false, DoctorRecordLabel: "Audio Record", date: Date.dateFromCustomString(customString: "\(ChatDate)")))
                        }

                    }
                    else if Doctor_ID != sender_id{
//                        print("Patient : \(documentData["text"] as! String)")
                        if documentData["type"] as! Int == 0{
                            print("3. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(ChatDate)")))
                        }
                        else if documentData["type"] as! Int == 1{
                            print("4. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: true,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(ChatDate)")))


                        }
                        else if documentData["type"] as! Int == 3{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: true, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(ChatDate)")))


                        }


                    }

                }
                
                let Grouping_Message = Dictionary(grouping: message, by: {(element) -> Date in
                    return element.date
                })
                print("Dictionary : \(Dictionary(grouping: message, by: { $0.date }))")

                print("Grouping_Message : \(Grouping_Message)")
                let keys = Grouping_Message.keys.sorted()
                print("keys : \(keys)")
                keys.forEach { (key) in
                    let values = Grouping_Message[key]
                    ChatMessage.append(values ?? [])
                    print("chatMessages : \(values)")
                }

              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
                
            }
      }
        
    }
    
    func AdminDoctorImage(cell: DoctorImageTableViewCell, didTappedThe button: UIButton?, index: Int,indexsec: Int) {
        print("index : \(index)")
        Image_url = ChatMessage[indexsec][index].url
        print("Image_url : \(Image_url) \(documentID)")
        performSegue(withIdentifier: "AdminImageZoom", sender: self)

    }
    
    func AdminImage(cell: AdminComImageTableViewCell, didTappedThe button: UIButton?, index: Int,indexsec: Int) {
        print("index : \(index)")
        Image_url = ChatMessage[indexsec][index].url
        print("Image_url : \(Image_url) \(documentID)")
        performSegue(withIdentifier: "AdminImageZoom", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "AdminImageZoom"{
            let VC:AdminimageZoomViewController = segue.destination as! AdminimageZoomViewController
            VC.documentID = documentID
            VC.Image_url = Image_url
        }    }
    
    
    
}


class CustomImageView: UIImageView {


    
}
