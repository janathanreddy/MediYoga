//
//  MontlyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 07/11/20.
//

import UIKit
import FSCalendar
import Firebase

class MontlyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MonthlyTitle: UIButton!
    @IBOutlet weak var Calender_View: UIView!
    var CalenderView:FSCalendar = FSCalendar()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()
    var datesWithEvent = [String]()
    var datesWithMultipleEvents = [String]()
    var AppointmentDate = [String]()
    var db = Firestore.firestore()
    var dates_1:String = ""
    var PatientTime = [String]()
    var PatientName = [String]()
    var PatientAge = [String]()
    var DoctorId:String = ""
    var Patient_Id:String = ""
    var Patient_ChatId = [String]()
    var PatientTimedid:String = ""
    var PatientNamedid:String = ""
    var PatientAgedid:String = ""
    var counts: [String: Int] = [:]




    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        tableView.register(UINib(nibName: "MonthlyTableViewCell", bundle: nil), forCellReuseIdentifier: "MonthlyView")
        tableView.showsVerticalScrollIndicator = false
        CalenderView.delegate = self
        CalenderView.dataSource = self
        Calender_View.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        retrieveData()
        
       
        
       


    }

       func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

           let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
           let formattteddate = dateFormatter.string(from: date)
           dates_1.append(formattteddate)
        print()
        Patient_ChatId.removeAll()
        PatientName.removeAll()
        PatientTime.removeAll()
        
        db.collection("appointments").whereField("appointment_date", isEqualTo:formattteddate).getDocuments(){ [self] (querySnapshot, error) in
                if  error == nil && querySnapshot != nil {

                for document in querySnapshot!.documents {
                let documentData = document.data()
                    Patient_ChatId.append(documentData["patient_id"] as! String)
                    PatientTime.append(documentData["appointment_time"] as! String)
                    PatientName.append("\(documentData["patient_first_name"] as! String) \(documentData["patient_last_name"] as! String)")
                    PatientAge.append("\(String(documentData["patient_age"] as! Int))")
                    
            
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        
       }
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PatientName.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let Cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyView", for: indexPath) as! MonthlyTableViewCell
    Cell.PatientName.text = PatientName[indexPath.row]
    Cell.AppointmentTime.text = PatientTime[indexPath.row]
    return Cell
}

    @IBAction func MonthlyActBtn(_ sender: Any) {
        print("Taped Monthly")
        

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PatientTimedid = PatientTime[indexPath.row]
        PatientAgedid = PatientAge[indexPath.row]
        PatientNamedid = PatientName[indexPath.row]
        Patient_Id = Patient_ChatId[indexPath.row]
        performSegue(withIdentifier: "MonthlyToPatientDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "MonthlytoPatientChat"{
            let VC:ComChatViewController = segue.destination as! ComChatViewController
            VC.Patient_Id = Patient_Id
        }else if segue.identifier == "MonthlyToPatientDetails"{
            let VC:PatientDetailsViewController = segue.destination as! PatientDetailsViewController
            VC.patient_id = Patient_Id
            VC.age = PatientAgedid
            VC.name = PatientNamedid
            VC.time = PatientTimedid
            VC.image = "32"
        }
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func retrieveData() {
        
            db.collection("appointments").getDocuments(){ [self] (querySnapshot, error) in
                if  error == nil && querySnapshot != nil {

                for document in querySnapshot!.documents {
                let documentData = document.data()

                    AppointmentDate.append(documentData["appointment_date"] as! String)
                    
            
    }
                    for item in AppointmentDate {
                        print("item : \(item)")

                        counts[item] = (counts[item] ?? 0) + 1
                    }

                    for (key, value) in counts {
                        if value > 1{
                            datesWithMultipleEvents.append(key)
                            print("datesWithMultipleEvents : \(datesWithMultipleEvents)")
                        }
                        else{
                            datesWithEvent.append(key)
                            print("datesWithEvent : \(datesWithEvent)")
                        }
                    }
                   
    }
                
            }
        
        
        
}

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter2.string(from: date)

        if self.datesWithEvent.contains(dateString) {

            calendar.appearance.eventDefaultColor = UIColor.systemPink
            return 1
        }
        else if self.datesWithMultipleEvents.contains(dateString) {
            calendar.appearance.eventDefaultColor = UIColor.systemYellow
            return 3
        }
        return 0

    }
    
}
