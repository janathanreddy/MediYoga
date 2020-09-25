//
//  SettingsViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var cell:[String] = ["cell_1","cell_2","cell_3","cell_4"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        self.navigationItem.setHidesBackButton(true, animated: true)


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
        return cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellForRow = tableView.dequeueReusableCell(withIdentifier: cell[indexPath.row]){
                return cellForRow
             }else{
               return UITableViewCell()
             }
    }
    
}
