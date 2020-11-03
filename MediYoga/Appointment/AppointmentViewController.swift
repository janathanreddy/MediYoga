//
//  AppointmentViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseABTesting
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AppointmentViewController: UIViewController, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, TableViewCellindex{
    
    @IBOutlet weak var DownArrow: UIButton!
    @IBOutlet weak var TodayWeeklyView: UIView!
    @IBOutlet weak var Todaytoptitle: UIButton!
    @IBOutlet weak var TodayBtn: UIButton!
    @IBOutlet weak var monthlybtn: UIButton!
    @IBOutlet weak var Weeklybtn: UIButton!
    @IBOutlet weak var namesearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    var searching = false
    var name_1 = [filternames]()
    var searchedname_1 = [filternames]()
    var selectindex: Int = 0
    var selectedpatient_id:String = ""
    var patient_id_notes:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        DownArrow.isUserInteractionEnabled = true
        namesearch.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        self.navigationItem.setHidesBackButton(true, animated: true)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM dd, yyyy"
        let formattedDate = format.string(from: date)
        tableView.showsVerticalScrollIndicator = false
        TodayWeeklyView.isHidden = true
        db.collection("appointments").whereField("appointment_date", isEqualTo: formattedDate).order(by: "appointment_time").getDocuments(){ (querySnapshot, error) in
                            if  error == nil && querySnapshot != nil {

                            for document in querySnapshot!.documents {
                            let documentData = document.data()
                            let patient_first_name = documentData["patient_first_name"] as! String
                            let patient_id = documentData["patient_id"] as! String
                            let patient_age = String(documentData["patient_age"] as! Int)
                            let patient_gender = documentData["patient_gender"]as! String
                            let appointment_time = documentData["appointment_time"] as! String
                            let appointment_date = documentData["appointment_date"] as! String
                            
                                self.name_1.append(filternames(name: patient_first_name,image:"35",age:patient_age,time:appointment_time,ccd:"CCD",at:"AT.png",patient_id:patient_id))

                    }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                }
            }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedname_1.count
        } else {
            return name_1.count
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        namesearch.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppointmentTableViewCell
        if searching {
            
            cell.NameField.text = searchedname_1[indexPath.row].name
            cell.appointmentimage.image = UIImage(named: searchedname_1[indexPath.row].image)
            cell.AgeField.text = searchedname_1[indexPath.row].age
            cell.TimeField.text = searchedname_1[indexPath.row].time
            cell.ccdField.text = searchedname_1[indexPath.row].ccd
            cell.statusField.image = UIImage(named: searchedname_1[indexPath.row].at)
            return cell

        } else {
                cell.appointmentimage.image = UIImage(named: name_1[indexPath.row].image)
                cell.NameField.text = name_1[indexPath.row].name
                cell.AgeField.text = name_1[indexPath.row].age
                cell.TimeField.text = name_1[indexPath.row].time
                cell.ccdField.text = name_1[indexPath.row].ccd
                cell.statusField.image = UIImage(named: name_1[indexPath.row].at)
                cell.celldelegate = self
                cell.index = indexPath
                return cell
        }
        return UITableViewCell()
    }
    
    
    func OnTouch(index: Int) {
        
        selectedpatient_id = name_1[index].patient_id
        performSegue(withIdentifier: "NotesSegue", sender: self)

    }

    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DeatailofPatient", sender: self)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotesSegue"{

           let Notes:NOTESViewController = segue.destination as! NOTESViewController
           Notes.patient_id = selectedpatient_id
            
       }
        else if segue.identifier == "DeatailofPatient" {
            if let indexPath = self.tableView.indexPathForSelectedRow{

            let VC:PatientDetailsViewController = segue.destination as! PatientDetailsViewController
            VC.name = self.name_1[indexPath.row].name
            VC.image = self.name_1[indexPath.row].image
            VC.time = self.name_1[indexPath.row].time
            VC.age = self.name_1[indexPath.row].age
            VC.cdd = self.name_1[indexPath.row].ccd
            VC.patient_id = self.name_1[indexPath.row].patient_id

            }
        }else if segue.identifier == "WeeklyViewController"{
            
        }
    }

    @IBAction func actionTodayWeekly(_ sender: Any) {
        DownArrow.isSelected = !DownArrow.isSelected
        Todaytoptitle.isSelected = !Todaytoptitle.isSelected
       if Todaytoptitle.isSelected == true || DownArrow.isSelected == true{
            self.TodayWeeklyView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.DownArrow.imageView!.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        })

        
       }else{
        self.TodayWeeklyView.isHidden = true
       }

    }
    
    @IBAction func TodayAct(_ sender: Any) {
        TodayWeeklyView.isHidden = true
        Todaytoptitle.setTitle("Today", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
              self.DownArrow.imageView!.transform = CGAffineTransform.identity
        })


    }
    
    
    @IBAction func Weeklyact(_ sender: Any) {
//        TodayWeeklyView.isHidden = true
//        Todaytoptitle.setTitle("Weekly", for: .normal)
//        UIView.animate(withDuration: 0.5, animations: {
//              self.DownArrow.imageView!.transform = CGAffineTransform.identity
//        })
        TodayWeeklyView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
              self.DownArrow.imageView!.transform = CGAffineTransform.identity
        })
        performSegue(withIdentifier: "WeeklyViewController", sender: self)

    }
    
    @IBAction func Monthlyact(_ sender: Any) {
        TodayWeeklyView.isHidden = true
        Todaytoptitle.setTitle("Monthly", for: .normal)
        
        UIView.animate(withDuration: 0.5, animations: {
              self.DownArrow.imageView!.transform = CGAffineTransform.identity
        })


    }
   

}
extension AppointmentViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        namesearch.showsCancelButton = true

        searchedname_1 = name_1.filter({$0.name.contains(searchText)})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        namesearch.text = ""
        namesearch.showsCancelButton = false
        tableView.reloadData()
    }
}
    
    
    




class filternames {
    let name: String
    let image: String
    let age: String
    let time: String
    let ccd: String
    let at:String
    let patient_id:String
    init(name: String,image: String,age: String,time: String,ccd: String,at: String,patient_id: String) {
        self.name = name
        self.image = image
        self.age = age
        self.time = time
        self.ccd = ccd
        self.at = at
        self.patient_id = patient_id
    }
}


