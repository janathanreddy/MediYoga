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
        validateFields()

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
        
        let MobileNo=MobileNoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password=PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        self.ErrorLabel.alpha = 1
        ErrorLabel.text = "Please Fill Mobile No and Text Field"
        self.dismiss(animated: false, completion: nil)


    }
    

    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    func validateFields() -> String? {
        if MobileNoTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines)==""||PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            return "Please Fill in all Fields"
        }
        let cleanpassword=PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if ViewController.isPasswordValid(cleanpassword)==false{
            return "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number"
        }
        return nil
    }
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

