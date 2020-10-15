//
//  CommunicationViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseABTesting
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CommunicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var CommunicationLabel: UILabel!
    @IBOutlet weak var NameSearch: UISearchBar!
    
    var searching = false
    
    var name_1 = [filtername]()
    var searchedname_1 = [filtername]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        NameSearch.delegate = self
        NameSearch.showsScopeBar = false
        self.db.collection("patient_chat").getDocuments { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  for document in snapshot!.documents {
                    let docId = document.documentID
                    let documentData = document.data()
                    let participant_name = documentData["jJU6FoDijkb3MOdu7Eeh"] as? [String:Any]
                    let last_message = documentData["last_message"] as? String
                    let ChatId = documentData["users"] as! [Any]
                    let last_message_time: Timestamp = documentData["last_message_time"] as! Timestamp
                    let timeStamp = last_message_time.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd"
                    let firebasedate = dateFormatter.string(from: timeStamp)
                    self.name_1.append(filtername(name: participant_name!["participant_name"] as! String, image: "32", message: last_message!, unread: String(participant_name!["unread_count"] as! Int), date: firebasedate, UserId: ChatId[1] as! String, documentID: docId, DoctorName: participant_name!["name"] as! String, DoctorId: ChatId[0] as! String ))
                    
                    self.searchedname_1 = self.name_1
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
            return searchedname_1.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CommunicationTableViewCell else {
            return UITableViewCell()
        }
        cell.nameField.text = searchedname_1[indexPath.row].name
        cell.chatimage.image = UIImage(named:searchedname_1[indexPath.row].image)
        cell.CountUnseen.text = searchedname_1[indexPath.row].unread
        cell.messageField.text = searchedname_1[indexPath.row].message
        cell.ComDate.text = searchedname_1[indexPath.row].date
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedname_1 = name_1.filter({ filtername -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return filtername.name.lowercased().contains(searchText.lowercased())
            default:
                return false
            }
        })
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            searchedname_1 = name_1
        
        default:
            break
        }
        tableView.reloadData()
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NameSearch.resignFirstResponder()
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        NameSearch.text = ""
        NameSearch.isHidden = true
        NameSearch.showsCancelButton = false
        SearchButton.isHidden = false
        CommunicationLabel.isHidden = false
        tableView.reloadData()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComSegue_1" {
            let VC:ComChatViewController = segue.destination as! ComChatViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            VC.GroupName = name_1[indexPath!.row].name
            VC.imagename = name_1[indexPath!.row].image
            VC.UserId = name_1[indexPath!.row].UserId
            VC.documentID = name_1[indexPath!.row].documentID
            VC.DoctorId = name_1[indexPath!.row].DoctorId
            VC.DoctorName = name_1[indexPath!.row].DoctorName
        }
        
                }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "ComSegue_1", sender: self)
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func SearchAction(_ sender: Any) {
        NameSearch.isHidden = false
        NameSearch.showsCancelButton = true
        SearchButton.isHidden = true
        CommunicationLabel.isHidden = true

    }
    
}

class filtername {
    let name: String
    let image: String
    let message: String
    let unread: String
    let date: String
    let UserId:String
    let documentID:String
    let DoctorName:String
    let DoctorId:String
    init(name: String,image: String,message: String,unread: String,date: String,UserId: String,documentID: String,DoctorName: String,DoctorId:String) {
        self.name = name
        self.image = image
        self.message  = message
        self.unread = unread
        self.date = date
        self.UserId = UserId
        self.documentID = documentID
        self.DoctorName = DoctorName
        self.DoctorId = DoctorId
    }
    

}
