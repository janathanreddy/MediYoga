//
//  PriscriptionViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class PriscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewNew, UISearchBarDelegate {
    
    
    @IBOutlet var NameSearch: UISearchBar!
    
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var names:[String] = ["Tylenol","Celecoxib","Meloxicam","Nabumetone","ibuprofen"]
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
        
            cell.PriscriptionLabel.text = searchedname[indexPath.row] }
        else{
            
                cell.PriscriptionLabel.text = names[indexPath.row]
        }

        cell.celldelegate = self
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
    
    
    
}

