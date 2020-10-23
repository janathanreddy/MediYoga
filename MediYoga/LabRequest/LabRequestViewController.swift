//
//  LabRequestViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit
import Firebase

struct cellData {
    var opened = Bool()
    var title = String()
    var imagepain = String()
    var sectiondata = [String]()
    
}

class LabRequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db = Firestore.firestore()
    var xibindexpath:IndexPath?
    var tableviewdata = [cellData]()
    var pains:[String] = ["Neck", "Head", "Shoulder", "Elbow", "Leg", "Hand", "Wrist"]
    
    var imagepains:[String] = ["Head.png","Neck.png","Back.png","Shoulder.png","Arm.png"]
    var xrays:[String] = ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]
    var pain = [String]()
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
                tableviewdata = [cellData(opened: false, title: "Neck",imagepain: "Neck.png",sectiondata: ["X-ray C-spine AP & Lat view","MRI C-spine","MRI C-spine with whole spine screening","MRI Left brachial plexus","MRI Right brachial plexus"]),cellData(opened: false, title: "Head",imagepain: "Head.png",sectiondata: ["X-ray PNS","X-Ray face with PNS","CT PNS","CT face PNS","CT Brains"]),cellData(opened: false, title: "Shoulder",imagepain: "Shoulder.png",sectiondata: ["X-ray Left shoulder AP view","X-ray Right shoulder AP view","X-ray Left shoulder scapula Y view/outlet view","X-ray Right shoulder Scapula Y view/Outlet view","CT Left shoulder with 3D recon, truction","CT Right shoulder with 3D recon, truction","MRI Left shoulder","MRI Right shoulder"]),
                    cellData(opened: false, title: "Arm",imagepain: "Arm.png",sectiondata:["X-ray Left elbow AP & oblique views","X-ray Right elbow AP & oblique views","CT Left elbow","CT Right elbow","MRI Left Elbow","MRI Right Elbow","MRI Both side"]),cellData(opened: false, title: "Leg",imagepain: "Back.png",sectiondata: ["X-ray Left tibia with ankle AP view","X-ray Right tibia with ankle AP view","X-ray Left tibia with knee AP view","X-ray Right tibia with knee AP view","MRI Left knee with leg","MRI Right knee with leg"]),cellData(opened: false, title: "Hand",imagepain: "Arm.png",sectiondata: ["X-ray Left hand AP & oblique views","X-ray Right hand AP & oblique views","X-ray Left wrist with hand AP view","X-ray Right wrist with hand AP view","MRI Left wrist with hand","MRI Right wrist with hand"]),cellData(opened: false, title: "Wrist",imagepain: "Arm.png",sectiondata: ["X-ray Left wrist AP & oblique views","X-ray Right wrist AP & oblique views","CT Left wrist","CT Right wrist","MRI Left wrist","MRI Right wrist"])]

        LabRequest()


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
    
    func LabRequest(){
        
        db.collection("lab_request").getDocuments() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for documents in snapshot!.documents {
                   let documents = documents.data()
                    pain.append(documents["region"] as! String)
                    print("pains : \(pain)")
                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

              }
        }
        
    }
}
    
    
    
    
    


