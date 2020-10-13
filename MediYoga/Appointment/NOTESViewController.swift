//
//  NOTESViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 09/10/20.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseABTesting
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class NOTESViewController: UIViewController, UITextViewDelegate {
    
    let db = Firestore.firestore()
    @IBOutlet weak var TextViewNotes: UITextView!
    var patient_id:String = ""
    var documentID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextViewNotes.layer.borderColor = UIColor.systemGray4.cgColor
        TextViewNotes.layer.borderWidth = 0.8
        TextViewNotes.resignFirstResponder()
        TextViewNotes.delegate = self
        
        db.collection("appointments").whereField("patient_id", isEqualTo: patient_id).getDocuments(){ (querySnapshot, error) in
                            if  error == nil && querySnapshot != nil {
                            for document in querySnapshot!.documents {
                                
                            let documentData = document.data()
                            self.documentID = document.documentID
                                self.TextViewNotes.text = (documentData["notes"] as! String)
                            
                            }
                        }
                        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            TextViewNotes.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func CancelAct(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OkayAct(_ sender: Any) {
        
        let newDocument = db.collection("appointments").document(documentID)
        newDocument.updateData(["notes": TextViewNotes.text!])
        self.dismiss(animated: true, completion: nil)

    }

}
