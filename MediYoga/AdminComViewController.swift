//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 30/09/20.
//

import UIKit

class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    fileprivate let application = UIApplication.shared
    var messages: [MessageData] = [MessageData(text: "Hi", isFirstUser: true),
                                   MessageData(text: "Hi,Hello", isFirstUser: false)]
    var imagename:String = ""
    var GroupName:String = ""
    var dateupdate: String?
    var isFirstUser: Bool = true
    var timeupdate: String?
    
   @IBOutlet weak var profileimage: UIImageView!
   @IBOutlet weak var TextField: UITextField!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var MessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        profileimage.layer.cornerRadius = 23
        profileimage.clipsToBounds = true
        tableView.layer.borderWidth = 0.3
        tableView.layer.borderColor = UIColor.black.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        TextField.layer.cornerRadius = 13.0
        TextField.layer.borderWidth = 1.0
        TextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: "33")
        MessageLabel.text = "Admin Group"

    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 0
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        TextField.borderStyle = UITextField.BorderStyle.roundedRect
//    }
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
    @IBAction func CameraAction(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminComTableViewCell
        cell.updateMessageCell(by: messages[indexPath.row])
        cell.ReadCheckLabelAdmin.text = "unread"
        cell.timeLabelAdmin.text = timeupdate
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        TextField.resignFirstResponder()
        date()
        time()
        var textFromField:String = TextField.text!
        if TextField != nil{
            messages.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: messages.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .top, animated: true)
//        isFirstUser = !isFirstUser
            TextField.text = ""}
       return true
        tableView.reloadData()
    }
}
