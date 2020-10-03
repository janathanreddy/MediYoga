//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 30/09/20.
//

import UIKit

class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var TableViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var ButtomConstraints: NSLayoutConstraint!
    @IBOutlet weak var ViewTop: UIView!
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
//        tableView.layer.borderWidth = 0.3
//        tableView.layer.borderColor = UIColor.black.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        TextField.layer.cornerRadius = 13.0
        TextField.layer.borderWidth = 1.0
        TextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: "33")
        MessageLabel.text = "Admin Group"
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)


    }
    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                
                var contentInset:UIEdgeInsets = self.tableView.contentInset

                self.tableView.contentInset = contentInset

                tableView.scrollToRow(at: IndexPath(row: messages.count - 1 , section: 0), at: .top, animated: true)
                contentInset.bottom = keyBoardRect!.height



                self.ButtomConstraints.constant = keyBoardHeight
//                self.TableViewConstraints.constant = keyBoardHeight
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    @objc func didTapView(){
      self.view.endEditing(true)
    }

    
    @objc func keyBoardWillHide(notification: Notification){
        
        self.ButtomConstraints.constant = 0
//        self.TableViewConstraints.constant = 0
        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
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
