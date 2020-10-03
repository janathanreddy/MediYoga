//
//  ComChatViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit

class ComChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var ButtomSpace: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var messages: [MessageData] = [MessageData(text: "Hi", isFirstUser: true),
                                   MessageData(text: "Hi,Hello", isFirstUser: false),
                                   MessageData(text: "How are you", isFirstUser: true),
                                   MessageData(text: "fine you", isFirstUser: false),
                                   MessageData(text: "Where are you", isFirstUser: true),
                                   MessageData(text: "i am Chennai You", isFirstUser: false),
                                   MessageData(text: "okay", isFirstUser: true)]
    var imagename:String = ""
    var GroupName:String = ""
    var dateupdate: String?
    var isFirstUser: Bool = true
    var timeupdate: String?
    var sendimage:Bool? = false
    let imageCache = NSCache<AnyObject, AnyObject>()

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        TextField.layer.cornerRadius = 13.0
        TextField.layer.borderWidth = 1.0
        TextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: imagename)
        MessageLabel.text = GroupName
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        
        tableView.register(UINib(nibName: "ComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ComImageTableViewCell")

        if let savedImages = Image.loadImages() {
            images = savedImages
        } else {
            images = Image.loadSampleImages()
        }
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
                self.ButtomSpace.constant = keyBoardHeight

                var contentInset:UIEdgeInsets = self.tableView.contentInset

                self.tableView.contentInset = contentInset

                tableView.scrollToRow(at: IndexPath(row: messages.count - 1 , section: 0), at: .top, animated: true)
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

        self.ButtomSpace.constant = 0
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
    
    @IBAction func CameraAction(_ sender: AnyObject) {
        sendimage = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertViewController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertViewController.addAction(photoLibraryAction)
        }

        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
        
        alertViewController.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint)-> (Bool)  in
            return (one.constant < 0) && (one.secondItem == nil) &&  (one.firstAttribute == .width)
            }.first?.isActive = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let image = Image(imageData: selectedImage.pngData()!, recordID: String(data: selectedImage.pngData()!, encoding: .unicode)!)
            images.append(image)
            Image.saveImages(images)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sendimage == false{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_1", for: indexPath) as! ComChatTableViewCell
        cell.updateMessageCell(by: messages[indexPath.row])
        cell.ReadCheckLabel.text = "unread"
            cell.timeLabel.text = timeupdate
            return cell

        }else{
            print("true")
            let ComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComImageTableViewCell", for: indexPath) as! ComImageTableViewCell

            ComImageTableViewCell.sendimage.image = nil
            
            if let imageFromCache = imageCache.object(forKey: images[indexPath.row].recordID as AnyObject) as? UIImage {
                ComImageTableViewCell.sendimage.image = imageFromCache
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) { [self] in
                    if let index = tableView.indexPath(for: ComImageTableViewCell) {
                        if let data = images[index.row].imageData {
                            let imageToCache = UIImage(data: data)
                            imageCache.setObject(imageToCache!, forKey: images[indexPath.row].recordID! as AnyObject)
                            ComImageTableViewCell.sendimage.image = UIImage(data: data)
                            ComImageTableViewCell.setNeedsLayout()
                        }
                    }
                }
            }
            return ComImageTableViewCell
        }
        return UITableViewCell()

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
//        TextField.resignFirstResponder()
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
extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    
    
    
    
    
}
