//
//  ComChatViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit

class ComChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var messages: [MessageData] = [MessageData(text: "Hi", isFirstUser: true),MessageData(text: "Hi,Hello", isFirstUser: false),MessageData(text: "How are you", isFirstUser: true),MessageData(text: "fine you", isFirstUser: false),MessageData(text: "Where are you", isFirstUser: true),MessageData(text: "i am Chennai You", isFirstUser: false),MessageData(text: "okay", isFirstUser: true)]
    
    var isFirstUser: Bool = true

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
    }
    
    @IBAction func backsegue(_ sender: Any) {
    }
    
    @IBAction func CallBtnAction(_ sender: Any) {
    }
    
    @IBAction func CameraAction(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_1", for: indexPath) as! ComChatTableViewCell
        cell.updateMessageCell(by: messages[indexPath.row])
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
        var textFromField:String = TextField.text!
        if TextField != nil{
            messages.append(MessageData(text: textFromField, isFirstUser: isFirstUser))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: messages.count - 1, section: 0)], with: .fade)
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .top, animated: true)
        isFirstUser = !isFirstUser
            TextField.text = ""}
       return true
        tableView.reloadData()
    }

    
}
