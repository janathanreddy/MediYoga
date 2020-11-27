//
//  AdminimageZoomViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 27/11/20.
//

import UIKit
import Firebase

class AdminimageZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var ImageDetailLabel: UILabel!
    
    @IBOutlet weak var ScrollAdminView: UIScrollView!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ImageAdmin: UIImageView!
    
    var documentID:String?
    var Image_url:String?
    var db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollAdminView.delegate = self
        print("AdminimageZoomViewController : \(Image_url) \(documentID)")
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
        db.collection("internal_chat").document(documentID!).collection("messages").whereField("content_url",isEqualTo: Image_url).getDocuments(){ [self] (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in snapshot!.documents {
                            
                            let docId = document.documentID
                            let documentData = document.data()
                            let sender_id = documentData["sender_id"] as! String
                                   print("\(documentData["content_url"] as! String)")
                            let storageref = Storage.storage().reference(forURL: documentData["content_url"] as! String)
                            print("Matching : \(documentData["content_url"] as! String) = \(Image_url)")
                            let fetchref = storageref.getData(maxSize: 4*1024*1024)
                            { data, error in
                                if error != nil {
                                    print("image Upload Error")
                             } else {
                                
                                ActivityIndicator.isHidden = true
                                ActivityIndicator.stopAnimating()

                                ImageAdmin.image = UIImage(data: data!)
                                let time_Stamp = documentData["time_stamp"] as! Timestamp
                                let timeStamp = time_Stamp.dateValue()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                                let ChatTime = dateFormatter.string(from: timeStamp)
                                ImageDetailLabel.text = "\(ChatTime)"

                               self.reloadInputViews()
                             }
                            }
                               
                        }
                    }

                }


    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ImageAdmin
    }

    @IBAction func BactAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
