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
        

    }
    

    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

}

