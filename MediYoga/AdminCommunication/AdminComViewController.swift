//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit
import AVFoundation
import Firebase

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

}



class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate
//                              AdminGroupDoctorplay, AdminGroupplay
{
    
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
    
    
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SelectedImage: UIImageView!
    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var View_Chat_Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var message = [MessageDataAdmin]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                tableView.scrollToRow(at: IndexPath(row: message.count - 1 , section: 0), at: .top, animated: true)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message.count != 0 {
            ActivityIndicator.stopAnimating()
            
        }

        if message[indexPath.row].isFirstUser == false && message[indexPath.row].ReceiverImageBool == false{
            
            let AdminTextTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminTextTableViewCell", for: indexPath) as! AdminTextTableViewCell

            AdminTextTableViewCell.AdmintextView.layer.cornerRadius = 16
            AdminTextTableViewCell.AdminText.text = message[indexPath.row].text
            print(message[indexPath.row].text)
            AdminTextTableViewCell.ReadCheck.text = "unread"
            AdminTextTableViewCell.Admintime.text = message[indexPath.row].time
            
            return AdminTextTableViewCell
        }
        else if message[indexPath.row].sendimagebool == false && message[indexPath.row].ReceiverImageBool == true{
         if message[indexPath.row].sentimage != nil{
                let AdminComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminImageCell", for: indexPath) as! AdminComImageTableViewCell
            AdminComImageTableViewCell.AdminImage_View.layer.cornerRadius = 10
            AdminComImageTableViewCell.AdminImage_View.clipsToBounds = true
            AdminComImageTableViewCell.ChatImage.layer.cornerRadius = 10
            AdminComImageTableViewCell.ChatImage.clipsToBounds = true

            AdminComImageTableViewCell.ChatImage.image = message[indexPath.row].sentimage
            if message[indexPath.row].sentlabel == ""{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = true
            }else{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = false
                AdminComImageTableViewCell.AdminChatLabel.text = message[indexPath.row].sentlabel
            }
            return AdminComImageTableViewCell
        }}else if message[indexPath.row].sendimagebool == true && message[indexPath.row].isFirstUser == true{
            if message[indexPath.row].sentimage != nil{
                   let DoctorImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DoctorImageTableViewCell", for: indexPath) as! DoctorImageTableViewCell
                DoctorImageTableViewCell.DoctorImageView.layer.cornerRadius = 10
                DoctorImageTableViewCell.DoctorImageView.clipsToBounds = true
                DoctorImageTableViewCell.DoctorView.layer.cornerRadius = 10
                DoctorImageTableViewCell.DoctorView.clipsToBounds = true

                DoctorImageTableViewCell.DoctorImageView.image = message[indexPath.row].sentimage
               if message[indexPath.row].sentlabel == ""{
                DoctorImageTableViewCell.DoctorLabel.isHidden = true
               }else{
                DoctorImageTableViewCell.DoctorLabel.isHidden = false
                DoctorImageTableViewCell.DoctorLabel.text = message[indexPath.row].sentlabel
               }
               return DoctorImageTableViewCell
           }
            let DoctorImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DoctorImageTableViewCell", for: indexPath) as! DoctorImageTableViewCell
            DoctorImageTableViewCell.DoctorImageView.layer.cornerRadius = 10
            DoctorImageTableViewCell.DoctorImageView.clipsToBounds = true
            DoctorImageTableViewCell.DoctorView.layer.cornerRadius = 10
            DoctorImageTableViewCell.DoctorView.clipsToBounds = true
            let storageref = Storage.storage().reference(forURL: message[indexPath.row].url)
            
            let fetchref = storageref.getData(maxSize: 4*1024*1024)
            { data, error in
                if error != nil {
                    print("image Upload Error")
             } else {

                DoctorImageTableViewCell.DoctorImageView.image = UIImage(data: data!)
               self.reloadInputViews()
             }
            }
            if message[indexPath.row].sentlabel == ""{
                DoctorImageTableViewCell.DoctorLabel.isHidden = true
            }else{
                DoctorImageTableViewCell.DoctorLabel.isHidden = false
                DoctorImageTableViewCell.DoctorLabel.text = message[indexPath.row].sentlabel
            }
            return DoctorImageTableViewCell
        }else if message[indexPath.row].ReceiverImageBool == true && message[indexPath.row].isFirstUser == false{
            let AdminComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminComImageTableViewCell", for: indexPath) as! AdminComImageTableViewCell
            AdminComImageTableViewCell.AdminImage_View.layer.cornerRadius = 10
            AdminComImageTableViewCell.AdminImage_View.clipsToBounds = true
            AdminComImageTableViewCell.ChatImage.layer.cornerRadius = 10
            AdminComImageTableViewCell.ChatImage.clipsToBounds = true
            let storageref = Storage.storage().reference(forURL: message[indexPath.row].url)
            
            let fetchref = storageref.getData(maxSize: 4*1024*1024)
            { data, error in
                if error != nil {
                    print("image Upload Error")
             } else {

                AdminComImageTableViewCell.ChatImage.image = UIImage(data: data!)
               self.reloadInputViews()
             }
            }
            if message[indexPath.row].sentlabel == ""{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = true
            }else{
                AdminComImageTableViewCell.AdminChatLabel.isHidden = false
                AdminComImageTableViewCell.AdminChatLabel.text = message[indexPath.row].sentlabel
            }
            return AdminComImageTableViewCell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminComTableViewCell

            cell.Chat_View.layer.cornerRadius = 16
            cell.ChatLabel.text = message[indexPath.row].text
                   cell.ReadCheck.text = "unread"
            cell.ChatTime.text = message[indexPath.row].time
            
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
            message.append(MessageDataAdmin(text: ChatTextField.text!, time: timeupdate!, isFirstUser: true, sendimagebool: true, sentimage: images as? UIImage , sentlabel: ChatTextField.text!, url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false,DoctorRecordLabel: ""))

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
        if ChatTextField != nil{
            
            db.collection("internal_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": Doctor_ID,"sender_name": DoctorName,"text": textFromField,"time_stamp": FieldValue.serverTimestamp(),"type": 0])
            let newDocument = db.collection("internal_chat").document(documentID)
            newDocument.updateData(["last_message": textFromField,"last_message_time": FieldValue.serverTimestamp()])

            
            message.append(MessageDataAdmin(text: textFromField,time: timeupdate!,isFirstUser: true, sendimagebool: false, sentlabel: "",url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false,DoctorRecordLabel: ""))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 0), at: .top, animated: true)
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

                    if Doctor_ID == sender_id {
                        if documentData["type"] as! Int == 0{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: ""))
                            print("1. \(documentData["text"] as! String)")

                        }
                        else if documentData["type"] as! Int == 1{
                            print("2. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: true, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: ""))


                        }

                        else if documentData["type"] as! Int == 3{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: true,patientaudio: false, DoctorRecordLabel: "Audio Record"))
                        }

                    }
                    else if Doctor_ID != sender_id{
//                        print("Patient : \(documentData["text"] as! String)")
                        if documentData["type"] as! Int == 0{
                            print("3. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: ""))
                        }
                        else if documentData["type"] as! Int == 1{
                            print("4. \(documentData["text"] as! String)")

                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: true,doctoraudio: false,patientaudio: false, DoctorRecordLabel: ""))


                        }
                        else if documentData["type"] as! Int == 3{
                            message.append(MessageDataAdmin(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: true, DoctorRecordLabel: ""))


                        }


                    }

                }
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }

            }

      }

    }
    
//    func OnTouchDoctor(index: Int) {
//        <#code#>
//    }
//    
//    func OnTouchAdmin(index: Int){
//        
//    }
    
}



