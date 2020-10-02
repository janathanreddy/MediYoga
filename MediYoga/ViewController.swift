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
//        validateFields()

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
    
    
    
    @IBAction func LoginAction(_ sender: Any) {
        
        let MobileNo = MobileNoTextField.text!
        let password = PasswordTextField.text!
              
        let isValidatePhone = self.validation.validaPhoneNumber(phoneNumber: MobileNo)
              if (isValidatePhone == false)
                {
                    print("Mobile Number is valid")
                } else {
                    print("Mobile Number is not valid")
                    displayAlertMessage(messageToDisplay: "Mobile Number is not valid")
                }
              
        
        let isValidatePass = self.validation.validatePassword(password: password)
        if (isValidatePass == false)
          {
              print("Password is valid")
          } else {
              print("Password is not valid")
              displayAlertMessage(messageToDisplay: "Password is not valid")
          }
        
        if (isValidatePhone == true || isValidatePass == true) {
            displayAlertMessage(messageToDisplay: "All fields are correct")
                 print("All fields are correct")
              }
    }
    
    
    func displayAlertMessage(messageToDisplay: String)
       {
           let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
           
           let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
               
               print("Ok button tapped");
               
           }
           
           alertController.addAction(OKAction)
           
           self.present(alertController, animated: true, completion:nil)
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

