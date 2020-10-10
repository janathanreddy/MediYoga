//
//  NOTESViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 09/10/20.
//

import UIKit

class NOTESViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var TextViewNotes: UITextView!
    var patient_id:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        TextViewNotes.layer.borderColor = UIColor.systemGray4.cgColor
        TextViewNotes.layer.borderWidth = 0.8
        TextViewNotes.delegate = self
        print(patient_id)
        TextViewNotes.resignFirstResponder()


    }
    

    @IBAction func CancelAct(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OkayAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

}
