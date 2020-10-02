//
//  SignupViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
//import Firebase
//import FirebaseAuth

class SignupViewController: UIViewController {

    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var NameField: UITextField!
    
    @IBOutlet weak var MobileNumberField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    @IBOutlet weak var SignupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        SignupButton.clipsToBounds = true
        SignupButton.layer.cornerRadius = 10

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NameField.borderStyle = UITextField.BorderStyle.roundedRect
        MobileNumberField.borderStyle = UITextField.BorderStyle.roundedRect
        
        PasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        ConfirmPasswordField.borderStyle = UITextField.BorderStyle.roundedRect
        
       
    }
    @IBAction func SignupAction(_ sender: Any) {
        
        

        
        
        
        
        
//        PhoneAuthProvider.provider().verifyPhoneNumber(self.MobileNumberField.text!, uiDelegate: nil) { (verificationID, error) in
//            if error != nil {
//                print("eror: \(String(describing: error?.localizedDescription))")
//            } else {
//                let defaults = UserDefaults.standard
//                defaults.set(verificationID, forKey: "authVID")
//                self.performSegue(withIdentifier: "code", sender: Any?.self)
//            }
//        }
        
        
        
        
        
        
    }
    
    @IBAction func Name(_ sender: Any) {
        
        let text = NameField.text ?? ""
        if text.isValidName() {
            NameField.textColor = UIColor.black
            ErrorLabel.text = ""
        } else {
            NameField.textColor = UIColor.red
            ErrorLabel.text = "not valid name"
            SignupButton.isEnabled = false
        }
        
    }
    
    @IBAction func MobileNumber(_ sender: Any) {
        
        let text = MobileNumberField.text ?? ""

        if text.filterPhoneNumber().isValidPhone() {
            MobileNumberField.textColor = UIColor.black
            ErrorLabel.text = ""
        } else {
            MobileNumberField.textColor = UIColor.red
            ErrorLabel.text = "not valid phone"
            SignupButton.isEnabled = false

        }
        
    }
    
    @IBAction func Password(_ sender: Any) {
        
        let text = PasswordField.text ?? ""

        if text.isValidPassword() {
            PasswordField.textColor = UIColor.black
            ErrorLabel.text = "Strong Password"
            ErrorLabel.textColor = UIColor.green
        } else {
            PasswordField.textColor = UIColor.red
            ErrorLabel.text = "Weak password"
            ErrorLabel.textColor = UIColor.red
            SignupButton.isEnabled = false

        }
    }
        
    
    @IBAction func ConfirmPassword(_ sender: Any) {
        let text = ConfirmPasswordField.text ?? ""

        if text.isValidPassword() {
            ConfirmPasswordField.textColor = UIColor.black
            ErrorLabel.text = "Strong Password"
            ErrorLabel.textColor = UIColor.green
        } else {
            ConfirmPasswordField.textColor = UIColor.red
            ErrorLabel.text = "Weak password"
            ErrorLabel.textColor = UIColor.red
            SignupButton.isEnabled = false

        }
    }
}
extension String {
    func isValidName() -> Bool {
        let inputRegEx = "^[a-zA-Z\\_]{2,25}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidEmail() -> Bool {
        let inputRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[A-Za-z]{2,64}"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidPhone() -> Bool {
        let inputRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    func isValidPassword() -> Bool {
        let inputRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()-_+={}?>.<,:;~`']{8,}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
    
    public func filterPhoneNumber() -> String {
        return String(self.filter {!" ()._-\n\t\r".contains($0)})
    }
}
