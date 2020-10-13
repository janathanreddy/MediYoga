//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit

struct MessageDataAdmin {
    var text : String
    var time : String
    var isFirstUser : Bool
    var sendimagebool : Bool
    var sentimage : UIImage?
    var sentlabel:String
}

class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var dateupdate: String?
    var timeupdate: String?
    var GroupImage:String = ""
    var GroupName:String = ""

    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var View_Chat_Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var message: [MessageDataAdmin] = [MessageDataAdmin(text: "Hi,Hello", time: "7.00 PM",
                 isFirstUser: true, sendimagebool: false,sentlabel:""),
                MessageDataAdmin(text: "How are you", time: "8.00 PM", isFirstUser: true, sendimagebool: false,sentlabel:""),
                MessageDataAdmin(text: "fine you", time: "8.30 PM", isFirstUser: true, sendimagebool: false,sentlabel:"")]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

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
        
        tableView.register(UINib(nibName: "AdminComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminImageCell")

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

                tableView.scrollToRow(at: IndexPath(row: message.count - 1 , section: 0), at: .top, animated: true)
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
        if message[indexPath.row].isFirstUser == false{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminComTableViewCell

            cell.Chat_View.layer.cornerRadius = 16
            cell.ChatLabel.text = message[indexPath.row].text
                   cell.ReadCheck.text = "unread"
            cell.ChatTime.text = message[indexPath.row].time
                       return cell
        }
       
        else if message[indexPath.row].sentimage != nil{
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
        }else{
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
            message.append(MessageDataAdmin(text: ChatTextField.text!, time: timeupdate!, isFirstUser: true, sendimagebool: true, sentimage: images as? UIImage , sentlabel: ChatTextField.text!))
            ChatTextField.text = ""
            tableView.reloadData()

                } else {
                    print("Check Image Code Error !!!")
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
            message.append(MessageDataAdmin(text: textFromField,time: timeupdate!,isFirstUser: true, sendimagebool: false, sentlabel: ""))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: message.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 0), at: .top, animated: true)
            ChatTextField.text = ""
            
        }
        
       return true
        tableView.reloadData()
        
    }

    
}



