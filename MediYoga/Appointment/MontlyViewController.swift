//
//  MontlyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 07/11/20.
//

import UIKit
import FSCalendar
import Firebase

class MontlyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate, FSCalendarDataSource{
    
    @IBOutlet weak var DropArrow: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var MonthlyTitle: UIButton!
    
    @IBOutlet weak var TodayTitle: UIButton!
    
    @IBOutlet weak var WeeklyTitle: UIButton!
    
    @IBOutlet weak var MonthlyView: UIView!
    
    @IBOutlet weak var Calender_View: UIView!
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()

    var CalenderView:FSCalendar = FSCalendar()
    var datesWithEvent:[String] = []
    var datesWithMultipleEvents:[String] = []
    var AppointmentDate:[String] = []
    var db = Firestore.firestore()
    var dates_1:String = ""
    var PatientTime:[String] = []
    var PatientName:[String] = []



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
        CalenderView.rowHeight = 30
        CalenderView.reloadData()
        

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        MonthlyView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
              self.DropArrow.imageView!.transform = CGAffineTransform.identity
        })


    }

       func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

           let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
           let formattteddate = dateFormatter.string(from: date)
           dates_1.append(formattteddate)
        print()
        PatientName.removeAll()
        PatientTime.removeAll()
        
        db.collection("appointments").whereField("appointment_date", isEqualTo:formattteddate).getDocuments(){ [self] (querySnapshot, error) in
                if  error == nil && querySnapshot != nil {

                for document in querySnapshot!.documents {
                let documentData = document.data()
                    PatientTime.append(documentData["appointment_time"] as! String)
                    PatientName.append("\(documentData["patient_first_name"] as! String) \(documentData["patient_last_name"] as! String)")
            
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        
           tableView.reloadData()
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
        MonthlyView.isHidden = false

    }
    
    @IBAction func TodayActBtn(_ sender: Any) {
        print("Taped Today")
        MonthlyView.isHidden = true
        MonthlyTitle.setTitle("Today", for: .normal)
        
        UIView.animate(withDuration: 0.5, animations: {
              self.DropArrow.imageView!.transform = CGAffineTransform.identity
        })
        self.dismiss(animated: true, completion: nil)

    }

    
    @IBAction func WeeklyActBtn(_ sender: Any) {
        print("Taped Weekly")
        MonthlyView.isHidden = true
        MonthlyTitle.setTitle("Weekly", for: .normal)
        
        UIView.animate(withDuration: 0.5, animations: {
              self.DropArrow.imageView!.transform = CGAffineTransform.identity
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveData() {
        
            db.collection("appointments").getDocuments(){ [self] (querySnapshot, error) in
                if  error == nil && querySnapshot != nil {

                for document in querySnapshot!.documents {
                let documentData = document.data()

                    AppointmentDate.append(documentData["appointment_date"] as! String)
                    
            
    }

                    var counts: [String: Int] = [:]
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
        print("dateString : \(dateString)")

        if self.datesWithEvent.contains(dateString) {

            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())

            calendar.appearance.eventDefaultColor = UIColor(red:red, green: green, blue: blue, alpha: 1)
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())

            calendar.appearance.eventDefaultColor = UIColor(red:red, green: green, blue: blue, alpha: 1)
            return 3
        }
        CalenderView.reloadData()
        self.viewWillAppear(true)
        return 0
    }
}
