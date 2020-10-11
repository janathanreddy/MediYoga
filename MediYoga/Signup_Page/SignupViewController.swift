//
//  SignupViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
//import Firebase
//import FirebaseAuth

class SignupViewController: UIViewController,UITextViewDelegate {

    var validation = Validation()
    
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var MobileNumberField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    @IBOutlet weak var SignupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignupButton.clipsToBounds = true
        SignupButton.layer.cornerRadius = 10
        
        NameField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)
        MobileNumberField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)

        PasswordField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)
        ConfirmPasswordField.addTarget(nil, action:"firstResponderAction:", for:.editingDidEndOnExit)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NameField.borderStyle = UITextField.BorderStyle.roundedRect
        MobileNumberField.borderStyle = UITextField.BorderStyle.roundedRect
        
        PasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        ConfirmPasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        
        
       
    }
    @IBAction func SignupAction(_ sender: Any) {
        
        let password = PasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mobileno = MobileNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Name = MobileNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmpassword = MobileNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        print(mobileno.count)
        if mobileno == "" || password == "" || Name == "" || confirmpassword == ""{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill All Fields", preferredStyle: .alert)
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
        else if PasswordField.text != ConfirmPasswordField.text {
            let alertController = UIAlertController(title: "Alert", message:
                "Check Your Password Not Same ConfirmPassword", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Check Your Password Not Same ConfirmPassword")
        }
        else{
            performSegue(withIdentifier: "SignUPToLogin", sender: self)
        }
print("tapped")
    }
    

    
}