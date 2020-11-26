//
//  ImageZoomViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 26/11/20.
//

import UIKit
import Firebase

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var Scroll_View: UIScrollView!
    
    @IBOutlet weak var labelimage: UILabel!
    @IBOutlet weak var Scroll_Image: UIImageView!
    var db = Firestore.firestore()
    var Patient_Id:String?
    var Image_url:String?
    var documentID:String?
    var DoctorId: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        Scroll_View.delegate = self

        db.collection("patient_chat").document(documentID!).collection("messages").whereField("content_url",isEqualTo: Image_url).getDocuments(){ [self] (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {

                            let docId = document.documentID
                            let documentData = document.data()
                            let sender_id = documentData["sender_id"] as! String
                                   print("\(documentData["content_url"] as! String)")
                            let storageref = Storage.storage().reference(forURL: documentData["content_url"] as! String)
                            
                            let fetchref = storageref.getData(maxSize: 4*1024*1024)
                            { data, error in
                                if error != nil {
                                    print("image Upload Error")
                             } else {

                                Scroll_Image.image = UIImage(data: data!)
                                let time_Stamp = documentData["time_stamp"] as! Timestamp
                                let timeStamp = time_Stamp.dateValue()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                                let ChatTime = dateFormatter.string(from: timeStamp)
                                labelimage.text = "\(ChatTime)"

                               self.reloadInputViews()
                             }
                            }
                               
                        }
                    }

                }

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return Scroll_Image
    }
    

    @IBAction func Dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
