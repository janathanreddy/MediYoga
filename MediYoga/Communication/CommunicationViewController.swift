//
//  CommunicationViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class CommunicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        NameSearch.delegate = self
        appenddata()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedname_1.count
        }else{
            return name_1.count}
    }
    private func appenddata() {
        name_1.append(filtername(name: "Roamanson",image:"35"))
        name_1.append(filtername(name: "Jonny",image:"36"))
        name_1.append(filtername(name: "Anderson",image:"37"))
        name_1.append(filtername(name: "BikiDev",image:"38"))
        name_1.append(filtername(name: "Assik",image:"39"))
        name_1.append(filtername(name: "Kaamil",image:"40"))
        
//        searchedname_1 = name_1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunicationTableViewCell
        if searching{
            cell.chatimage.image = UIImage(named: searchedname_1[indexPath.row].image)
            cell.nameField.text = searchedname_1[indexPath.row].name
            return cell

        }else{
            cell.chatimage.image = UIImage(named: name_1[indexPath.row].image)
            cell.nameField.text = name_1[indexPath.row].name
            return cell

        }
        return UITableViewCell()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue!, sender: Any?){
//
//        let navVC = segue.destination as! UINavigationController
//
//        let tableVC = navVC.viewControllers.first as! CommunicationChatViewController
//        var indexpath = self.tableView.indexPathForSelectedRow
//        tableVC.GroupName = name_1[indexpath!.row].name
//        tableVC.imagename = name_1[indexpath!.row].image
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedname_1 = name_1.filter({$0.name.contains(searchText)})
        searching = true
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
    init(name: String,image: String) {
        self.name = name
        self.image = image
    }
}
