//
//  AppointmentViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class AppointmentViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var tableView: UITableView!
    
//    private var search = UISearchController(searchResultsController: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        Search_Bar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
//           navigationItem.hidesSearchBarWhenScrolling = true
       }
    
//    func Search_Bar(){
//        search.searchBar.delegate = self
//        search.searchBar.sizeToFit()
//        search.obscuresBackgroundDuringPresentation = false
//        search.hidesNavigationBarDuringPresentation = true
//        self.definesPresentationContext = true
//        search.searchBar.placeholder = "Search Appointment"
//        self.navigationItem.searchController = search
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApplicationTableViewCell
        return cell
        
    }

    
}
