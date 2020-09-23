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
    
    
}
