//
//  LabRequestViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class LabRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var pains:[String] = ["Head","Neck","Back","Shoulder","Arm"]
    var imagepains:[String] = ["Head.png","Neck.png","Back.png","Shoulder.png","Arm.png"]
    
    @IBOutlet weak var Descriptionlab: UITextField!
    
    
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savebtn.layer.cornerRadius = 10
        savebtn.clipsToBounds = true
        Descriptionlab.layer.borderColor = UIColor.systemGray4.cgColor
        Descriptionlab.layer.borderWidth = 1
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LabRequestTableViewCell
        cell.labIMAGE.image = UIImage(named:imagepains[indexPath.row])
        cell.labelname.text = pains[indexPath.row]
        return cell
    }
   
    @IBAction func saveAction(_ sender: Any) {
    }
    
}
