//
//  AdminComViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit

class AdminComViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var dateupdate: String?
    var timeupdate: String?


    var GroupImage:String = ""
    var GroupName:String = ""
    var messages = [MessageDataAdmin]()

    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var View_Chat_Image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var message: [MessageDataAdmin] = [MessageDataAdmin(text: "Hi,Hello", time: "7.00 PM",
                 isFirstUser: false, sendimagebool: false,sentlabel:""),
                MessageDataAdmin(text: "How are you", time: "8.00 PM", isFirstUser: true, sendimagebool: false,sentlabel:""),
                MessageDataAdmin(text: "fine you", time: "8.30 PM", isFirstUser: true, sendimagebool: false,sentlabel:"")]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        profileimage.layer.cornerRadius = 23
        profileimage.clipsToBounds = true
        self.picker.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        ChatTextField.layer.cornerRadius = 13.0
        ChatTextField.layer.borderWidth = 1.0
        ChatTextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: imagename)
        MessageLabel.text = GroupName
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        
        tableView.register(UINib(nibName: "ComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ComImageTableViewCell")

        tableView.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminComTableViewCell
        return Cell
    }

    @IBAction func CameraAct(_ sender: Any) {
    }
    
    @IBAction func BackSegue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Miceact(_ sender: Any) {
    }
    
    @IBAction func CallAct(_ sender: Any) {
    }
    
}
