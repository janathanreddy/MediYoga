//
//  ComChatViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit
import Firebase


struct messagedata {
    var text : String
    var time : String
    var isFirstUser : Bool
    var sendimagebool : Bool
    var sentimage:UIImage?
    var sentlabel:String
}

class ComChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    @IBOutlet weak var ButtomSpace: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var message = [messagedata]()
    @IBOutlet weak var camerabutton: UIButton!
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var imagename:String = ""
    var GroupName:String = ""
    var UserId:String = ""
    var dateupdate: String?
    var timeupdate: String?
    var documentID: String = ""

    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MessageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        messages()
        print("UserId: \(UserId) , documentID: \(documentID)")
        tableView.delegate = self
        tableView.dataSource = self
        profileimage.layer.cornerRadius = 20
        profileimage.clipsToBounds = true
        self.picker.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        TextField.layer.cornerRadius = 13.0
        TextField.layer.borderWidth = 1.0
        TextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: imagename)
        MessageLabel.text = GroupName
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        tableView.register(UINib(nibName: "ComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ComImageTableViewCell")

        tableView.rowHeight = UITableView.automaticDimension
        scrollToBottom()
    }
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }

    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.ButtomSpace.constant = keyBoardHeight
                var contentInset:UIEdgeInsets = self.tableView.contentInset
                self.tableView.contentInset = contentInset
                tableView.scrollToRow(at: IndexPath(row: message.count - 1 , section: 0), at: .top, animated: true)
                contentInset.bottom = keyBoardRect!.height
                _ = NSIndexPath(row: 1, section: 0)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset

        self.ButtomSpace.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
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
    @IBAction func backsegue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CallBtnAction(_ sender: UIButton) {
        if let phoneURL = URL(string: "tel://9003660005"){
            if application.canOpenURL(phoneURL){
                application.open(phoneURL,options: [:],completionHandler: nil)
            }
        }
    }
    
    @IBAction func CameraAction(_ sender: AnyObject) {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        present(picker,animated: true,completion: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
             tableView.reloadData()
         }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        date()
        time()
        
        if let images = info[UIImagePickerController.InfoKey.originalImage] {
            message.append(messagedata(text: TextField.text!, time: timeupdate!, isFirstUser: true, sendimagebool: true, sentimage: images as? UIImage , sentlabel: TextField.text!))
            
            
            TextField.text = ""
            tableView.reloadData()
            scrollToBottom()

                } else {
                    print("Check Image Code Error !!!")
                }
                
                self.dismiss(animated: true, completion: nil)
        
        
         }
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if message[indexPath.row].isFirstUser == false{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_1", for: indexPath) as! ComChatTableViewCell

            cell.messageBackgroundView.layer.cornerRadius = 16
            cell.CellMessageLabel.text = message[indexPath.row].text
                   cell.ReadCheckLabel.text = "unread_1"
            cell.timeLabel.text = message[indexPath.row].time
                       return cell
        }
       
        else if message[indexPath.row].sentimage != nil{
                let ComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComImageTableViewCell", for: indexPath) as! ComImageTableViewCell
            ComImageTableViewCell.sendimageview.layer.cornerRadius = 10
            ComImageTableViewCell.sendimageview.clipsToBounds = true
            ComImageTableViewCell.sendimage.layer.cornerRadius = 10
            ComImageTableViewCell.sendimage.clipsToBounds = true

            ComImageTableViewCell.sendimage.image = message[indexPath.row].sentimage
            if message[indexPath.row].sentlabel == ""{
                ComImageTableViewCell.sendlabel.isHidden = true
            }else{
                ComImageTableViewCell.sendlabel.isHidden = false
                ComImageTableViewCell.sendlabel.text = message[indexPath.row].sentlabel
            }
            return ComImageTableViewCell
        }
            else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_1", for: indexPath) as! ComChatTableViewCell
            cell.messageBackgroundView.layer.cornerRadius = 16
            cell.CellMessageLabel.text = message[indexPath.row].text
                   cell.ReadCheckLabel.text = "unread"
            cell.timeLabel.text = message[indexPath.row].time
                       return cell
        }

return UITableViewCell()

    }
    
    func scrollToBottom() {
            if message.count >= 5 {
            DispatchQueue.main.async {
                let indexpath = IndexPath(row: self.message.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
            }
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        date()
        time()
        let textFromField:String = TextField.text!
        if TextField != nil{
            
            db.collection("patient_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": UserId,"sender_name": GroupName,"text": textFromField,"time_stamp": FieldValue.serverTimestamp(),"type": 0])
            let newDocument = db.collection("patient_chat").document(documentID)
            newDocument.updateData(["last_message": textFromField,"last_message_time": FieldValue.serverTimestamp()])

            print(FieldValue.serverTimestamp())
            message.append(messagedata(text: textFromField,time: timeupdate!,isFirstUser: true, sendimagebool: false, sentlabel: ""))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 0), at: .top, animated: true)
            TextField.text = ""
            
        }
       return true
        tableView.reloadData()
    }

    func messages(){
    
        db.collection("patient_chat").document(documentID).collection("messages").order(by: "time_stamp").getDocuments(){ [self] (snapshot, err) in
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
                    if sender_id == UserId {
                        message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true, sendimagebool: false, sentlabel: ""))

                    }
                    
                }
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }

            }
      }
        
    }
}
    
    
    
    


