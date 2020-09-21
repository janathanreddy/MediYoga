//
//  ViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController{
   
    

    
    let button = UIButton(type: .custom)
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var MobileNoTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 10
        PasswordTextField.rightViewMode = .unlessEditing
        button.setImage(UIImage(named: "eye.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: -24, bottom: 1, right: 15)
        button.frame = CGRect(x: CGFloat(PasswordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.passwordVissible), for: .touchUpInside)
        PasswordTextField.rightView = button
        PasswordTextField.rightViewMode = .always
        PasswordTextField.isSecureTextEntry = true

    }

    override func viewDidAppear(_ animated: Bool) {
        MobileNoTextField.borderStyle = UITextField.BorderStyle.roundedRect
        PasswordTextField.borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    @IBAction func passwordVissible(_ sender: Any){
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected{
            self.PasswordTextField.isSecureTextEntry = false
        }
        else{
            self.PasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
//        let phoneNumber = "+16505554567"
//
//        // This test verification code is specified for the given test phone number in the developer console.
//        let testVerificationCode = "123456"

        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(MobileNoTextField.text!, uiDelegate:nil) { [self]
                                                                    verificationID, error in
            if ((error) != nil) {
              // Handles error
//              self.handleError(error)
                print("1. \(error?.localizedDescription)")
              return
            }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
                                                                     verificationCode: PasswordTextField.text!)
            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
                if ((error) != nil) {
                // Handles error
//                self.handleError(error)
                    print("2. \(error!.localizedDescription)")
                return
              }
                var user = authData!.user
                print(" hi \(user)")
                self.performSegue(withIdentifier: "logged", sender: Any?.self)

            }
        }
        
    }
    
    
}

