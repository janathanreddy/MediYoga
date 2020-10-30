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
    var fianlupdate = [Int]()
    var patient_id:String = ""
    var names = [String]()
    var searching = false
    var searchedname = [String]()
    var SelectedFav = [String]()
    var selectedElement = [String]()
    var RetFav = [String]()
    @IBOutlet weak var prescriptionLabel: UILabel!
    @IBOutlet weak var SaveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextFieldDescription: UITextField!
    var CurrentDate:String = ""
    var selecteddrugs = [String]()
    var Favindex = [Int]()
    var RetFavIndex = [Int]()
    var RetFav_Index = [Int]()
    var Favouritedrugs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        date()
        indexselect()
        tableView.delegate = self
        tableView.dataSource = self
        SaveBtn.layer.cornerRadius = 10
        NameSearch.delegate = self
        TextFieldDescription.textAlignment = .left
        TextFieldDescription.contentVerticalAlignment = .top
        messages()
        print("patient_id from Priscription : \(patient_id) ")
        selecteddruglist()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedname.count
        } else {
            return names.count
        }
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if searching{

            let searchingcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PriscriptionTableViewCell

            searchingcell.PriscriptionLabel.text = searchedname[indexPath.row]
            searchingcell.celldelegate = self
            searchingcell.index = indexPath
           
            return searchingcell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PriscriptionTableViewCell
            for RET in RetFav{
                if RET == names[indexPath.row]{
                    
                    cell.favbtn.isSelected = true
                }
            }
            cell.PriscriptionLabel.text = names[indexPath.row]
            cell.celldelegate = self
            cell.index = indexPath
            return cell

        }

        return UITableViewCell()
    }

    
    

    
    func Favourite(cell: PriscriptionTableViewCell, didTappedThe button: UIButton?) {

        cell.favbtn.isSelected = !cell.favbtn.isSelected
        if button?.isSelected != true{
            guard let indexPath = tableView.indexPath(for: cell) else  { return }
            Favouritedrugs = Favouritedrugs.filter() { $0 != "\(names[indexPath.row])" }
            Favindex = Favindex.filter() { $0 != indexPath.row }
            print("Favindex Deselected: \(Favindex)")
            print("Deselected Favouritedrugs : \(Favouritedrugs)")
            reloadInputViews()
        }else if button?.isSelected != false{
            
           guard let indexPath = tableView.indexPath(for: cell) else  { return }
            
            Favouritedrugs.append(names[indexPath.row])
            Favindex.append(indexPath.row)
            print("Favindex Selected: \(Favindex)")
            print("Selected Favouritedrugs : \(Favouritedrugs)")
            reloadInputViews()
        }
       }
    
    func Check(cell: PriscriptionTableViewCell, didTappedThe button: UIButton?) {

        cell.checkbtn.isSelected = !cell.checkbtn.isSelected
        if button?.isSelected != true{
            
           guard let indexPath = tableView.indexPath(for: cell) else  { return }
            selecteddrugs = selecteddrugs.filter() { $0 != "\(names[indexPath.row])" }
            print("Check Deselected: \(selecteddrugs)")
            reloadInputViews()

        }else if button?.isSelected != false{
            guard let indexPath = tableView.indexPath(for: cell) else  { return }
            selecteddrugs.append(names[indexPath.row])
            print("Check Selected: \(selecteddrugs)")
            reloadInputViews()

            
        }
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
        
        
        db.collection("prescription").document("drug_document").getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    
                    for documents in document.value as! [[String:Any]]{
                        names.append(documents["drug_name"] as! String)
                    }
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }
    }
    
    @IBAction func SaveAct(_ sender: Any) {
        
        db.collection("prescription").document("drug_document").getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    for documents in document.value as! [[String:Any]]{
                        for Favouritedrug in Favouritedrugs{
                            print("Favouritedrugs_Save : \(Favouritedrugs)")
                            if Favouritedrug == documents["drug_name"] as! String{
                                print("drug_name : \(documents["drug_name"] as! String)")
                                print("drug_id : \(documents["drug_id"] as! Int)")
                                RetFav_Index.append(documents["drug_id"] as! Int)
                                RetFavIndex.append(documents["drug_id"] as! Int)
                                let array = Array(NSOrderedSet(array: RetFav_Index))
                                print("RetFavIndex : \(array)")
                                db.collection("doctors").document("jJU6FoDijkb3MOdu7Eeh").setData(["favourite_drugs": array])
                            }
                        }

                    }
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }
        
    }
    
    
    func date(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        CurrentDate = dateFormatter.string(from: date)
        
        
    }
    func selecteddruglist(){
        
        db.collection("prescription").document("drug_document").getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    for documents in document.value as! [[String:Any]]{
                        for favIndex in RetFavIndex{
                            if favIndex == documents["drug_id"] as! Int{
                                let favIndex = (documents["drug_name"] as! String)
                                RetFav.append(favIndex)
                                print("RetFav : \(RetFav)")
                                Favouritedrugs.append(favIndex)
                                
                                
                            }
                        }
                    }
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }


              }
        }
    }
   
    func indexselect() {
        
        db.collection("doctors").document("jJU6FoDijkb3MOdu7Eeh").getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String : Any] {
                    if document.key == "favourite_drugs" {
                        for documents in document.value as! [Any]{
                            RetFavIndex.append(documents as! Int)
                            print("indexselect : \(RetFavIndex)")
                        }
                    }
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }
    }
    
}



