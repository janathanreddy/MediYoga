//
//  AppointmentViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit
import Firebase
import FirebaseABTesting
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AppointmentViewController: UIViewController, UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var namesearch: UISearchBar!
    @IBOutlet weak var BlurEffect: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var NotesView: UIView!
    
    @IBOutlet weak var TextViewField: UITextView!
    
    let db = Firestore.firestore()
    var searching = false
    var name_1 = [filternames]()
    var searchedname_1 = [filternames]()


    override func viewDidLoad() {
        super.viewDidLoad()
        namesearch.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        TextViewField.layer.borderColor = UIColor.systemGray.cgColor
        TextViewField.layer.borderWidth = 0.8
        self.navigationItem.setHidesBackButton(true, animated: true)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d, yyyy"
        let formattedDate = format.string(from: date)
//        currentdate = formattedDate
//        print(currentdate)
        print("outer \(formattedDate)")
        tableView.showsVerticalScrollIndicator = false
//        appenddata()

        db.collection("appointments").whereField("appointment_date", isEqualTo: formattedDate).order(by: "appointment_time").getDocuments(){ (querySnapshot, error) in
                            if  error == nil && querySnapshot != nil {

                            for document in querySnapshot!.documents {
                            let documentData = document.data()
                            var patient_first_name = documentData["patient_first_name"] as! String
                            var patient_id = documentData["patient_id"] as! String
                            var patient_age = String(documentData["patient_age"] as! Int)
                            var patient_gender = documentData["patient_gender"]as! String
                            var appointment_time = documentData["appointment_time"] as! String
                            var appointment_date = documentData["appointment_date"] as! String
//                             print(appointment_date,patient_first_name,patient_id,patient_age,patient_gender,appointment_time)
                                print(formattedDate)
//                            let patient_symptoms = documentData["patient_symptoms"] as? [Any]
//                            print(" hi \(patient_symptoms?[1])")
                            
//                            print(patient_first_name,patient_id,patient_age,patient_gender,appointment_time)
                            
                                self.name_1.append(filternames(name: patient_first_name,image:"35",age:patient_age,time:appointment_time,ccd:"CCD",at:"AT.png"))

                    }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                }
            }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        tableView.reloadData()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    

    private func appenddata() {
        
        
//        name_1.append(filternames(name: documentData["patient_first_name"] as! String,image:"35",age:documentData["patient_age"] as! Int,time:documentData["appointment_time"] as! String,ccd:"CCD",at:"AT.png"))
//        name_1.append(filternames(name: "Roamanson",image:"35",age:"32",time:"8:40AM-8.50AM",ccd:"CCD",at:"AT.png"))
//        name_1.append(filternames(name: "Jonny",image:"36",age:"31",time:"8:50AM-9.00AM",ccd:"CDD",at:"FC.png"))
//        name_1.append(filternames(name: "Anderson",image:"37",age:"36",time:"9:00AM-9.10AM",ccd:"LDD",at:"old.png"))
//        name_1.append(filternames(name: "BikiDev",image:"38",age:"37",time:"9.10AM-9.20AM",ccd:"CCD/LDD",at:"MT.png"))
//        name_1.append(filternames(name: "Assik",image:"39",age:"26",time:"9:20AM-9.40AM",ccd:"CCD",at:"N.png"))
//        name_1.append(filternames(name: "Kaamil",image:"40",age:"28",time:"9:40AM-10.00AM",ccd:"CDD",at:"AT.png"))
//        name_1.append(filternames(name: "Johnson",image:"31",age:"29",time:"10:00AM-10.10AM",ccd:"LDD",at:"FC.png"))
//        name_1.append(filternames(name: "Maclarn",image:"32",age:"31",time:"10:10AM-10.20AM",ccd:"CCD/LDD",at:"old.png"))
//        name_1.append(filternames(name: "Chuva",image:"33",age:"22",time:"10:20AM-10.30AM",ccd:"LDD",at:"N.png"))
//        name_1.append(filternames(name: "Lee",image:"34",age:"21",time:"10:30AM-10.40AM",ccd:"CCD",at:"MT.png"))
        
        
//        searchedname_1 = name_1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if searching {
//            return searchedname_1.count
//        } else {
            return name_1.count
        print(name_1.count)
//        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        namesearch.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApplicationTableViewCell
//        if searching {
//            cell.NameField.text = searchedname_1[indexPath.row].name
//            cell.appointmentimage.image = UIImage(named: searchedname_1[indexPath.row].image)
//            cell.AgeField.text = searchedname_1[indexPath.row].age
//            cell.TimeField.text = searchedname_1[indexPath.row].time
//            cell.ccdField.text = searchedname_1[indexPath.row].ccd
//            cell.statusField.image = UIImage(named: searchedname_1[indexPath.row].at)
//            return cell
//
//        } else {
//        print(name_1[indexPath.row].name,name_1[indexPath.row].age,name_1[indexPath.row].time)
        
                cell.appointmentimage.image = UIImage(named: name_1[indexPath.row].image)
                cell.NameField.text = name_1[indexPath.row].name
                cell.AgeField.text = name_1[indexPath.row].age
                cell.TimeField.text = name_1[indexPath.row].time
                cell.ccdField.text = name_1[indexPath.row].ccd
                cell.statusField.image = UIImage(named: name_1[indexPath.row].at)
            return cell

//        }
//
//        cell.delegate = self
//        cell.index = indexPath
//        return UITableViewCell()
            
        
        
        
    }
    
    func animateIn(desiredView:UIView){
        
        let backgroundView = self.view
        backgroundView?.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView?.center as! CGPoint
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
            desiredView.alpha = 1

        })
        
    }
    
    func  animatedismiss(desiredView:UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
            desiredView.alpha = 0
        },completion: { _ in desiredView.removeFromSuperview()} )
    }

    @IBAction func NotesButtonAction(_ sender: Any) {
        animateIn(desiredView: NotesView)
        animateIn(desiredView: BlurEffect)


    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        name_1 = name[indexPath.row]
//        age_1 = age[indexPath.row]
//        time_1 = time[indexPath.row]
//        ccd_1 = ccd[indexPath.row]
//        image_1 = image[indexPath.row]
       performSegue(withIdentifier: "DeatailofPatient", sender: self)

    }
    @IBAction func CancelNotes(_ sender: Any) {
        animatedismiss(desiredView: BlurEffect)
        animatedismiss(desiredView: NotesView)
    }
    
    @IBAction func OkNotes(_ sender: Any) {
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeatailofPatient" {
            let VC:PatientDetailsViewController = segue.destination as! PatientDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            VC.name = self.name_1[indexPath!.row].name
            VC.image = self.name_1[indexPath!.row].image
            VC.time = self.name_1[indexPath!.row].time
            VC.age = self.name_1[indexPath!.row].age
            VC.cdd = self.name_1[indexPath!.row].ccd

                }
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
    init(name: String,image: String,age: String,time: String,ccd: String,at: String) {
        self.name = name
        self.image = image
        self.age = age
        self.time = time
        self.ccd = ccd
        self.at = at
    }
    
}
