//
//  CaseHistoryViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 27/09/20.
//

import UIKit

class CaseHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var pains:[String] = ["Neck Pain","Joint Pain","Ellbow Pain","Shoulder Pain","Giddiness"]
    var dates:[String] = ["23 Aug,2019","28 Jun,2019","25 Feb,2019","07 Feb,2019","23 Nov,2019"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70

    }
    @IBAction func backsegue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! checkhistoryTableViewCell
        cell.label_1.text = pains[indexPath.row]
        cell.label_2.text = dates[indexPath.row]
        return cell
    }
}
