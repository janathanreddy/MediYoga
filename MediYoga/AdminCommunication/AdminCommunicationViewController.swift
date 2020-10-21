//
//  AdminCommunicationViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
import Firebase

class AdminCommunicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    let db = Firestore.firestore()
    var AdminDetails = [AdminGroup]()
    @IBOutlet weak var tableView: UITableView!
    var image:[String] = ["33.jpg"]
    var Doctor_ID:String = ""
    var Admin_ID:String = ""
    var documentID:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.db.collection("internal_chat").getDocuments { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  for document in snapshot!.documents {
                    let docId = document.documentID
                    documentID.append(docId)
                    let documentData = document.data()
                    let Doctor_Id = documentData["jJU6FoDijkb3MOdu7Eeh"] as? [String:Any]
                    let Admin_Id = documentData["PjCfYtARzXUC99Py8vlM"] as? [String:Any]
                    let last_message = documentData["last_message"] as? String
                    let ChatId = documentData["users"] as! [Any]
                    let last_message_time: Timestamp = documentData["last_message_time"] as! Timestamp
                    let timeStamp = last_message_time.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd"
                    let firebasedate = dateFormatter.string(from: timeStamp)
                    
                    AdminDetails.append(AdminGroup(AdminName: Doctor_Id!["name"] as! String, time: firebasedate ,last_message: last_message!,Doctor_ID: ChatId[0] as! String,Admin_ID: ChatId[1] as! String, DoctorName: Doctor_Id!["name"] as! String, unread_count: Doctor_Id!["unread_count"] as! Int))
                    print("documentData : \(documentData) , docId : \(docId)")
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdminDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminCommunicationTableViewCell
        cell.Time.text = AdminDetails[indexPath.row].time
        cell.Last_Message.text = AdminDetails[indexPath.row].last_message
        cell.imagechat.image = UIImage(named: image[indexPath.row])
        cell.UnseenCount.text = String(AdminDetails[indexPath.row].unread_count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AdminSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdminSegue" {
            let VC:AdminComViewController = segue.destination as! AdminComViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            VC.GroupName = "Admin Group"
            VC.GroupImage = image[indexPath!.row]
            VC.Doctor_ID = AdminDetails[indexPath!.row].Doctor_ID
            VC.Admin_ID = AdminDetails[indexPath!.row].Admin_ID
            VC.documentID = documentID
            VC.DoctorName = AdminDetails[indexPath!.row].DoctorName

        }

                }

}


class AdminGroup {
    let AdminName: String
    let time: String
    let last_message: String
    let Doctor_ID: String
    let Admin_ID: String
    let DoctorName: String
    let unread_count: Int
    init(AdminName: String,time: String,last_message: String,Doctor_ID: String,Admin_ID: String,DoctorName: String,unread_count: Int) {
        self.AdminName = AdminName
        self.time = time
        self.last_message = last_message
        self.Doctor_ID = Doctor_ID
        self.Admin_ID = Admin_ID
        self.DoctorName = DoctorName
        self.unread_count = unread_count
    }
    

}
