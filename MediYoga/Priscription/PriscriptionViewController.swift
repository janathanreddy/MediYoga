//
//  PriscriptionViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit
import Firebase

class PriscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewNew, UISearchBarDelegate {
    
    
    @IBOutlet var NameSearch: UISearchBar!
    let db = Firestore.firestore()
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var patient_id:String = ""
    var names = [String]()
    var searching = false
    var searchedname = [String]()
    @IBOutlet weak var prescriptionLabel: UILabel!
    @IBOutlet weak var SaveBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextFieldDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        SaveBtn.layer.cornerRadius = 10
        NameSearch.delegate = self
        TextFieldDescription.textAlignment = .left
        TextFieldDescription.contentVerticalAlignment = .top
        messages()
        print("patient_id from Priscription : \(patient_id) ")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedname.count
        } else {
            return names.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PriscriptionTableViewCell
        if searching{
        
            cell.PriscriptionLabel.text = searchedname[indexPath.row]
            cell.celldelegate = self
            cell.index = indexPath
        }
        else{
            
                cell.PriscriptionLabel.text = names[indexPath.row]
            cell.celldelegate = self
            cell.index = indexPath

        }

        return cell
    }

    func onClickCell(index: Int) {
        print(index)
    }
    
    func onClickCell_1(index: Int) {
        print(index)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedname = names.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        searching = true
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NameSearch.resignFirstResponder()
        NameSearch.isHidden = true
        backButton.isHidden = false
        NameSearch.showsCancelButton = false
        SearchButton.isHidden = false
        prescriptionLabel.isHidden = false

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        NameSearch.text = ""
        NameSearch.isHidden = true
        backButton.isHidden = false
        NameSearch.showsCancelButton = false
        SearchButton.isHidden = false
        prescriptionLabel.isHidden = false
        tableView.reloadData()


    }

    @IBAction func search(_ sender: UISearchBar) {
        print("button tapped")
        NameSearch.isHidden = false
        backButton.isHidden = true
        NameSearch.showsCancelButton = true
        SearchButton.isHidden = true
        prescriptionLabel.isHidden = true

    }
    
    @IBAction func backsegue(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
    func messages(){
        
        
        db.collection("patient_prescriptions").document(patient_id).getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    for documents in document.value as! [[String:Any]]{
                        TextFieldDescription.text = documents["prescription_notes"] as! String
                        for DrugList in documents["drugs"] as! [[String:Any]]{
                            names.append(DrugList["drug_name"] as! String)
                        }
                    }
                    
                    
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }
    }
    
    @IBAction func SaveAct(_ sender: Any) {
        
        
    }
    
}



