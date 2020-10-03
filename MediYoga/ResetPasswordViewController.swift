//
//  ResetPasswordViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class ResetPasswordViewController: UIViewController {
var validation = Validation()
    @IBOutlet weak var CurrentPasswordField: UITextField!
    
    
    @IBOutlet weak var NewPasswordField: UITextField!
    
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    @IBOutlet weak var ChangePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangePasswordButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CurrentPasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        NewPasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        ConfirmPasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        let alertController = UIAlertController(title: "Alert", message:
                                                    "After Reset Password Login Again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)

        
    }
  
    @IBAction func BackSegue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
       
    }
   
    
    @IBAction func ResetPassWordAct(_ sender: Any) {
        
        print("tapped")
        let CurrentPassword = CurrentPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let NewPassword = NewPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let ConfirmPassword = ConfirmPasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if CurrentPassword == "" || NewPassword == "" || ConfirmPassword == "" {
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill Secure Password1", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        }
//        else if mobileno.count < 10 || mobileno.count > 10{
//          print("Enter Your 10 Digits Mobile Number")
//
//            let alertController = UIAlertController(title: "Alert", message:
//                "Check Your Mobile Number", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
//
//            self.present(alertController, animated: true, completion: nil)
//
//        }

        else if validation.validatePassword(password: NewPassword)==false || validation.validatePassword(password: ConfirmPassword)==false ||
                    validation.validatePassword(password: CurrentPassword) == false{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number")
        }
       
        else if NewPasswordField.text != ConfirmPasswordField.text {
            let alertController = UIAlertController(title: "Alert", message:
                "Check Your Password Not Same ConfirmPassword", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Check Your New Password Not Same Confirm Password")
        }
        else if CurrentPasswordField.text == NewPasswordField.text || CurrentPasswordField.text == ConfirmPasswordField.text{
            let alertController = UIAlertController(title: "Alert", message:
                                                        "Make sure New Password and CurrentPassword Same !. Change New One ...", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Make sure New Password and CurrentPassword Same Change New One")
        }
        else{
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
}
