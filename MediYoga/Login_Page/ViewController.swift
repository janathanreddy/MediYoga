//
//  ViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
//import FirebaseAuth
//import Firebase

class ViewController: UIViewController,UITextFieldDelegate{
   
    
    @IBOutlet weak var txtbc: NSLayoutConstraint!
    var validation = Validation()

    @IBOutlet weak var ErrorLabel: UILabel!
    
    let button = UIButton(type: .custom)
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var MobileNoTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 10
        PasswordTextField.rightViewMode = .unlessEditing
        button.setImage(UIImage(named: "eyeclose.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: -24, bottom: 1, right: 15)
        button.frame = CGRect(x: CGFloat(PasswordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.passwordVissible), for: .touchUpInside)
        PasswordTextField.rightView = button
        PasswordTextField.rightViewMode = .always
        PasswordTextField.isSecureTextEntry = true
        PasswordTextField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)
        MobileNoTextField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)
        MobileNoTextField.delegate = self
        PasswordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)


    }

    override func viewDidAppear(_ animated: Bool) {
        MobileNoTextField.borderStyle = UITextField.BorderStyle.roundedRect
        PasswordTextField.borderStyle = UITextField.BorderStyle.roundedRect

    }
    
    
    @IBAction func passwordVissible(_ sender: Any){
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected{
            self.PasswordTextField.isSecureTextEntry = false
            button.setImage(UIImage(named: "eye.png"), for: .normal)

        }
        else{
            self.PasswordTextField.isSecureTextEntry = true
            button.setImage(UIImage(named: "eyeclose.png"), for: .normal)

        }
    }
    
    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.txtbc.constant = keyBoardHeight
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    
    @objc func keyBoardWillHide(notification: Notification){
        
        self.txtbc.constant = 183.5
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    
    @IBAction func LoginAction(_ sender: Any) {
        
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mobileno = MobileNoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        print(mobileno.count)
        if mobileno == "" || password == ""{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill Both 10 digit Mobile Number and Secure Password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        }
        else if mobileno.count < 10 || mobileno.count > 10{
          print("Enter Your 10 Digits Mobile Number")
            
            let alertController = UIAlertController(title: "Alert", message:
                "Check Your Mobile Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)

        }

        else if validation.validatePassword(password: password)==false{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number")
        }
        else{
            performSegue(withIdentifier: "LoginToTab", sender: self)
        }
    }
    
    
    

    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
//    func validateFields() -> String? {
//        if MobileNoTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines)==""||PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
//            return "Please Fill in all Fields"
//        }
//        let cleanpassword=PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        if ViewController.isPasswordValid(cleanpassword)==false{
//            return "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number"
//        }
//        return nil
//    }
//    static func isPasswordValid(_ password : String) -> Bool {
//
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
//    }
}

