//
//  ResetPasswordViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class ResetPasswordViewController: UIViewController {

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
    }
  
    @IBAction func BackSegue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
