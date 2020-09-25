//
//  PriscriptionViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class PriscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewNew {
    
    
   
    var names:[String] = ["Tylenol","Celecoxib","Meloxicam","Nabumetone","ibuprofen"]

    @IBOutlet weak var SaveBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextFieldDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        SaveBtn.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PriscriptionTableViewCell
        cell.PriscriptionLabel.text = names[indexPath.row]

//        cell.checkbtn.addTarget(self, action: #selector(checkmarck(_:)), for: .touchUpInside)
//        cell.favbtn.addTarget(self, action: #selector(favourite(_:)), for: .touchUpInside)
        cell.celldelegate = self
        return cell
    }

    func onClickCell(index: Int) {
        print(index)
    }
    
    func onClickCell_1(index: Int) {
        print(index)
    }
//    @objc func checkmarck(_ sender: UIButton){
//        UIButton.isSelected = !buttonOutlet.isSelected
//
//    }
//    @objc func favourite(_ sender: UIButton){
//        UIButton.isSelected = !buttonOutlet.isSelected
//
//    }
    @IBAction func backsegue(_ sender: Any) {
        

        dismiss(animated: true, completion: nil)

    }
    
}
