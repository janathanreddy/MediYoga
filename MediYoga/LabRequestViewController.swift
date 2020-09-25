//
//  LabRequestViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class LabRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var xibindexpath:IndexPath?
    var pains:[String] = ["Head","Neck","Back","Shoulder","Arm"]
    var imagepains:[String] = ["Head.png","Neck.png","Back.png","Shoulder.png","Arm.png"]
    var xrays:[String] = ["X-ray PNS","X-Ray face wirh PNS","CT PNS","CT PNS","CT Brains"]
    var touch:Int?
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
        tableView.register(UINib(nibName: labxibTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: labxibTableViewCell.reuseIdentifier())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if xibindexpath != nil {
            return pains.count + 1
        } else {
            return pains.count
        }
    }
    @IBAction func backsegue(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if xibindexpath == indexPath {

            let xibcell = tableView.dequeueReusableCell(withIdentifier: labxibTableViewCell.reuseIdentifier()) as! labxibTableViewCell
            xibcell.dropdownlabel.text = xrays[indexPath.row]
            return xibcell
            
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LabRequestTableViewCell
            cell.labIMAGE.image = UIImage(named:imagepains[indexPath.row])
            cell.labelname.text = pains[indexPath.row]
                return cell

        }
    }
    @IBAction func saveAction(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.beginUpdates()
            if let xibindexpath = xibindexpath, xibindexpath.row - 1 == indexPath.row {
                tableView.deleteRows(at: [xibindexpath], with: .fade)
                self.xibindexpath = nil
            } else {
                if let datePickerIndexPath = xibindexpath {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
                }
                xibindexpath = indexPathToInsertDatePicker(indexPath: indexPath)
                tableView.insertRows(at: [xibindexpath!], with: .fade)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            tableView.endUpdates()
        }
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let xibindexpath = xibindexpath, xibindexpath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }



    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if xibindexpath == indexPath {
            return labxibTableViewCell.cellHeight()
        } else {
            return LabRequestTableViewCell.cellHeight()
        }
    }
    
}
    
    
    
    
    


