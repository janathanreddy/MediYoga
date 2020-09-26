//
//  LabRequestViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var imagepain = String()
    var sectiondata = [String]()
    
}

class LabRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var xibindexpath:IndexPath?
    var tableviewdata = [cellData]()
    var pains:[String] = ["Head","Neck","Back","Shoulder","Arm"]
    var imagepains:[String] = ["Head.png","Neck.png","Back.png","Shoulder.png","Arm.png"]
    var xrays:[String] = ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]
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
        tableviewdata = [cellData(opened: false, title: "Head",imagepain: "Head.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]),
                         cellData(opened: false, title: "Neck",imagepain: "Neck.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]),
                         cellData(opened: false, title: "Back",imagepain: "Back.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]),
                         cellData(opened: false, title: "Shoulder",imagepain: "Shoulder.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]),
                         cellData(opened: false, title: "Arm",imagepain: "Arm.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"])]
        tableView.register(UINib(nibName: labxibTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: labxibTableViewCell.reuseIdentifier())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewdata.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableviewdata[section].opened == true{
            return tableviewdata[section].sectiondata.count + 1
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! LabRequestTableViewCell
            LabRequestTableViewCell.cellHeight()
            cell.labIMAGE.image = UIImage(named: tableviewdata[indexPath.section].imagepain)
            cell.labelname.text = tableviewdata[indexPath.section].title
            return cell
        }
        else{
            let xibcell = tableView.dequeueReusableCell(withIdentifier: "labxibTableViewCell",for: indexPath) as! labxibTableViewCell
            labxibTableViewCell.cellHeight()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            xibcell.dropdownlabel.text = tableviewdata[indexPath.section].sectiondata[indexPath.row - 1]
            return xibcell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if tableviewdata[indexPath.section].opened == true{
            tableviewdata[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }else{
            tableviewdata[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)

        }
    }
    @IBAction func backsegue(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    
}
    
    
    
    
    


