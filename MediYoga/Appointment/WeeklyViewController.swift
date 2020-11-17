//
//  WeeklyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 31/10/20.
//

import UIKit
import Firebase
import Foundation


class WeeklyViewController: UIViewController{
   
    let db = Firestore.firestore()
    var Time:[String] = [""]
    var week:[String] = ["Time"]
    var nxtweek:[String] = [""]
    var Sunday = [String: String]()
    var Monday = [String: String]()
    var Tuesday = [String: String]()
    var Wednesday = [String: String]()
    var Thursday = [String: String]()
    var Friday = [String: String]()
    var Saturday = [String: String]()
    var SundayPatient_id = [String: String]()
    var MondayPatient_id = [String: String]()
    var TuesdayPatient_id = [String: String]()
    var WednesdayPatient_id = [String: String]()
    var ThursdayPatient_id = [String: String]()
    var FridayPatient_id = [String: String]()
    var SaturdayPatient_id = [String: String]()
    var Sundate:String = ""
    var Mondate:String = ""
    var Tuedate:String = ""
    var Weddate:String = ""
    var Thudate:String = ""
    var Fridate:String = ""
    var Satdate:String = ""
    var cel = [String]()
    var selectedpatient_id:String = ""
    var SelectedName:String = ""
    var Selectedtime:String = ""
    var count:Int = 0




    @IBOutlet weak var NextWeek: UIButton!
    @IBOutlet weak var PreviousWeek: UIButton!
    
    @IBOutlet weak var WeekLabel: UILabel!
    
    @IBOutlet weak var grid_CollectionView: UICollectionView! {
        didSet {
            grid_CollectionView.bounces = false
        }
    }
    @IBOutlet weak var gridLayout: StickyGrid_CollectionViewLayout! {
        didSet {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 1
        }
    }
    
    @IBOutlet weak var WeeklyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DoctorAppointments()
        currentweekdays()
        Week_Day()
        grid_CollectionView.delegate = self
        grid_CollectionView.dataSource = self
        grid_CollectionView.showsHorizontalScrollIndicator = false
        grid_CollectionView.showsVerticalScrollIndicator = false
        grid_CollectionView.register(UINib(nibName: "CollectionViewCell_1", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell_1")

    }
    func currentweekdays(){
        week.removeAll()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let nextWeek:Date =  calendar.date(byAdding: .weekOfMonth, value: count, to: today)! as Date
        let dayOfWeek = calendar.component(.weekday, from: nextWeek)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: nextWeek)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: nextWeek) }
    let formatter = DateFormatter()
    formatter.dateFormat = "dd,EEE"
            for date in days {
                if count == 0{
                    week.append(formatter.string(from: date))
                }else{
                    week.append(formatter.string(from: date))
                }
                }
        week.insert("Time", at: 0)

    }
   
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func DoctorAppointments(){
        db.collection("appointments").getDocuments(){ [self] (querySnapshot, error) in
            if  error == nil && querySnapshot != nil {

            for document in querySnapshot!.documents {
            let documentData = document.data()
                let isoDate = documentData["appointment_date"] as! String
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_IN")
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let date = dateFormatter.date(from:isoDate)
                let dayformate = DateFormatter()
                dayformate.dateFormat = "dd,EEE"
                
                let day = dayformate.string(from: date!)
                if day == week[1]{
                    Sunday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    SundayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Sundate = day
                
                }else if day == week[2]{
                    Monday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    MondayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Mondate = day
                    
                }else if day == week[3]{
                    Tuesday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    TuesdayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Tuedate = day


                
                }else if day == week[4]{
                    Wednesday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    WednesdayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Weddate = day


                
                }else if day == week[5]{
                    Thursday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    ThursdayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Thudate = day


                
                }else if day == week[6]{
                    Friday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    FridayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Fridate = day


                
                }else if day == week[7]{
                    Saturday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    SaturdayPatient_id.updateValue("\(documentData["patient_id"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    Satdate = day


                
                }

    }

        DispatchQueue.main.async {
            self.grid_CollectionView.reloadData()
        }
        
}
}
    }

    
    @IBAction func PreviousWeekAct(_ sender: Any) {
        
        

        count -= 1
        PreviousWeek.isSelected = true
        NextWeek.isSelected = false
        currentweekdays()
        grid_CollectionView.reloadData()

        Sunday.removeAll()
        Monday.removeAll()
        Tuesday.removeAll()
        Wednesday.removeAll()
        Thursday.removeAll()
        Friday.removeAll()
        Saturday.removeAll()
        DoctorAppointments()


    }
    
    @IBAction func NextWeekAct(_ sender: Any) {
        
        count += 1
        NextWeek.isSelected = true
        PreviousWeek.isSelected = false
        currentweekdays()
        grid_CollectionView.reloadData()

        Sunday.removeAll()
        Monday.removeAll()
        Tuesday.removeAll()
        Wednesday.removeAll()
        Thursday.removeAll()
        Friday.removeAll()
        Saturday.removeAll()
        DoctorAppointments()
        

        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WeeklytoPatientDetails"{

           let VC:PatientDetailsViewController = segue.destination as! PatientDetailsViewController
           VC.patient_id = selectedpatient_id
            VC.cdd = "LDD/CDD"
            VC.time = Selectedtime
            VC.age = "40"
            VC.name = SelectedName
            VC.image = "35"
            
       }
   
    }
    

}
extension WeeklyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: 150, height: 90)
        }
        return CGSize(width: 150, height: 90)
    }
}
extension WeeklyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Time.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return week.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell

        if indexPath.section == 0{

            cell!.title_Label.text = week[indexPath.row]
            cell!.title_Label.textColor = UIColor.white
            cell!.title_Label.font = UIFont.boldSystemFont(ofSize: 23)
            cell!.layer.borderWidth = 0.8
            cell!.title_Label.alpha = 1
            cell!.layer.borderColor = UIColor.systemGray6.cgColor
            cell!.backgroundColor = UIColor.systemBlue

            }

        else if indexPath.item == 0 && indexPath.section >= 1{
            cell!.title_Label.text = Time[indexPath.section]
            cell!.title_Label.textColor = UIColor.black
            cell!.title_Label.font = cell!.title_Label.font.withSize(21)
            cell!.title_Label.alpha = 0.6
            cell!.layer.borderWidth = 0.8
            cell!.layer.borderColor = UIColor.systemGray6.cgColor
            cell!.backgroundColor = UIColor.systemFill
            
        }
        else if indexPath.item == 1 && indexPath.section >= 1 {
            let cell_1 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_1!.Label_1.text = ""
            if Sunday.isEmpty != false && Sundate.isEmpty != false{
                cell_1?.Label_1.text = ""
                

            }
            else{
                for i in week{
                    for (key,value) in Sunday{
                        if Time[indexPath.section] == key && i == Sundate {


                            cell_1!.Label_1.text = value
                            cell_1!.Label_1.textColor = UIColor.systemBlue
                            cell_1!.Label_1.font = cell_1!.Label_1.font.withSize(20)
                            cell_1!.backgroundColor = UIColor.clear

                        }

                    }
                }
                
            }

            cell_1!.backgroundColor = UIColor.white
            cell_1!.layer.borderWidth = 0.8
            cell_1!.layer.borderColor = UIColor.systemGray5.cgColor


            return cell_1!

        }
        
        else if indexPath.item == 2 && indexPath.section >= 1  {
            let cell_2 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_2?.Label_1.text = ""
            if Monday.isEmpty != false && Mondate.isEmpty != false{
                cell_2?.Label_1.text = ""
            }
            else{
                for i in week{
                    for (key,value) in Monday{
                        if Time[indexPath.section] == key && i == Mondate {

                            cell_2!.Label_1.text = value
                            cell_2!.Label_1.textColor = UIColor.systemBlue
                            cell_2!.Label_1.font = cell_2!.Label_1.font.withSize(20)
                            cell_2!.backgroundColor = UIColor.clear

                        }

                    
                }
            }
            }
            cell_2!.backgroundColor = UIColor.white
            cell_2!.layer.borderWidth = 0.8
            
            cell_2!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_2!

            
            
        }
        else if indexPath.item == 3 && indexPath.section >= 1 {
            let cell_3 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_3?.Label_1.text = ""
            if Tuesday.isEmpty != false && Tuedate.isEmpty != false{
                cell_3?.Label_1.text = ""
                cell_3!.backgroundColor = UIColor.clear

            }
            else{
                for i in week{
                    for (key,value) in Tuesday{
                        if Time[indexPath.section] == key && i == Tuedate {
                            

                            cell_3!.Label_1.text = value
                            cell_3!.Label_1.textColor = UIColor.systemBlue
                            cell_3!.Label_1.font = cell_3!.Label_1.font.withSize(20)
                            cell_3!.backgroundColor = UIColor.clear

                        }

                    }
                }
            }

            cell_3!.backgroundColor = UIColor.white
            cell_3!.layer.borderWidth = 0.8
            cell_3!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_3!

        }
        else if indexPath.item == 4 && indexPath.section >= 1 {
            let cell_4 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_4?.Label_1.text = ""
            if Wednesday.isEmpty != false{
                cell_4!.Label_1.text = ""
                cell_4!.backgroundColor = UIColor.clear

            }
            else{
                for i in week{
                    for (key,value) in Wednesday{
                        if Time[indexPath.section] == key && i == Weddate {
                            

                            cell_4!.Label_1.text = value
                            cell_4!.Label_1.textColor = UIColor.systemBlue
                            cell_4!.Label_1.font = cell_4!.Label_1.font.withSize(20)
                            cell_4!.backgroundColor = UIColor.clear

                        }

                    }
                }
            }
            cell_4!.backgroundColor = UIColor.white
            cell_4!.layer.borderWidth = 0.8
            cell_4!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_4!

        }
        else if indexPath.item == 5 && indexPath.section >= 1 {
            let cell_5 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_5?.Label_1.text = ""
            if Thursday.isEmpty != false{
                cell_5!.Label_1.text = ""
            }
            else{
                for i in week{
                    for (key,value) in Thursday{

                        if Time[indexPath.section] == key && i == Thudate {
                            

                            cell_5!.Label_1.text = value
                            cell_5!.Label_1.textColor = UIColor.systemBlue
                            cell_5!.Label_1.font = cell_5!.Label_1.font.withSize(20)
                            cell_5!.backgroundColor = UIColor.clear

                        }

                    }
                }
            }

            cell_5!.backgroundColor = UIColor.white
            cell_5!.layer.borderWidth = 0.8
            cell_5!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_5!

        }
        else if indexPath.item == 6 && indexPath.section >= 1 {
            let cell_6 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            cell_6?.Label_1.text = ""
            if Friday.isEmpty != false{
                cell_6?.Label_1.text = ""
            }
            else{
                for i in week{
                    print("i : \(i)")

                    for (key,value) in Friday{
                        print("i : \(i) \((key,value))")
                        
                        if Time[indexPath.section] == key && i == Fridate {
                            print(Time[indexPath.section],key,i,Fridate)
                            

                            cell_6!.Label_1.text = value
                            cell_6!.Label_1.textColor = UIColor.systemBlue
                            cell_6!.Label_1.font = cell_6!.Label_1.font.withSize(20)
                            cell_6!.backgroundColor = UIColor.clear
                            print("cel : \(cel)")


                        }

                    }
                }
            }
            cell_6!.backgroundColor = UIColor.white
            cell_6!.layer.borderWidth = 0.8
            cell_6!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_6!

        }
        else if indexPath.item == 7 && indexPath.section >= 1 {
            let cell_7 = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewCell_1", for: indexPath) as? CollectionViewCell_1
            
            cell_7?.Label_1.text = ""
            
            if Saturday.isEmpty != false{
                cell_7?.Label_1.text = ""
            }
            else{
                for i in week{
                    for (key,value) in Saturday{
                        if Time[indexPath.section] == key && i == Satdate {
                            

                            cell_7!.Label_1.text = value
                            cell_7!.Label_1.textColor = UIColor.systemBlue
                            cell_7!.Label_1.font = cell_7!.Label_1.font.withSize(20)
                            cell_7!.backgroundColor = UIColor.clear

                        }

                    }
                }
            }
            cell_7!.backgroundColor = UIColor.white
            cell_7!.layer.borderWidth = 0.8
            cell_7!.layer.borderColor = UIColor.systemGray5.cgColor

            return cell_7!

        }
        
        


        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedpatient_id.removeAll()

        if String(week[indexPath.row].dropFirst(3)) == "Sun"{
            for (key,value) in Sunday{
                if Time[indexPath.section] == key {

                    SelectedName = value
                    
                }
            }
                            for (key,value) in SundayPatient_id{
                                if Time[indexPath.section] == key {
                                    
                                    selectedpatient_id = value
                                    Selectedtime = key

                                    performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

                            }
            
                            }

        }else if String(week[indexPath.row].dropFirst(3)) == "Mon"{
            
                for (key,value) in Monday{
                    if Time[indexPath.section] == key {

                        SelectedName = value
                        
                    }
                }
                            for (key,value) in MondayPatient_id{
                                if Time[indexPath.section] == key {
                                    selectedpatient_id = value
                                    Selectedtime = key

                                    performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

                            }
            
                            }

        }else if String(week[indexPath.row].dropFirst(3)) == "Tue"{
            for (key,value) in Tuesday{
                if Time[indexPath.section] == key {

                    SelectedName = value
                    
                }
            }
            for (key,value) in TuesdayPatient_id{
                if Time[indexPath.section] == key {
                    selectedpatient_id = value
                    Selectedtime = key

                    performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

            }

            }

}else if String(week[indexPath.row].dropFirst(3)) == "Wed"{
    for (key,value) in Wednesday{
        if Time[indexPath.section] == key {

            SelectedName = value
            
        }
    }
    for (key,value) in WednesdayPatient_id{
        if Time[indexPath.section] == key {
            selectedpatient_id = value
            Selectedtime = key

            performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

    }

    }

}else if String(week[indexPath.row].dropFirst(3)) == "Thu"{
    for (key,value) in Thursday{
        if Time[indexPath.section] == key {

            SelectedName = value
            
        }
    }
    for (key,value) in ThursdayPatient_id{
        if Time[indexPath.section] == key {
            selectedpatient_id = value
            Selectedtime = key

            performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

    }

    }

}else if String(week[indexPath.row].dropFirst(3)) == "Fri"{
    for (key,value) in Friday{
        if Time[indexPath.section] == key {

            SelectedName = value
            
        }
    }
    for (key,value) in FridayPatient_id{
        if Time[indexPath.section] == key {
            selectedpatient_id = value
            Selectedtime = key

            performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

    }

    }

}else if String(week[indexPath.row].dropFirst(3)) == "Sat"{
    for (key,value) in Saturday{
        if Time[indexPath.section] == key {

            SelectedName = value
            
        }
    }
    for (key,value) in SaturdayPatient_id{
        if Time[indexPath.section] == key {
            selectedpatient_id = value
            Selectedtime = key
            performSegue(withIdentifier: "WeeklytoPatientDetails", sender: self)

    }

    }

}
    }
    
    
    func Week_Day(){
    db.collection("week_slot").getDocuments(){ [self] (querySnapshot, error) in
                        if  error == nil && querySnapshot != nil {
                        for document in querySnapshot!.documents {
                        let documentData = document.data()
                            for Documents in documentData.values{
                                for time in Documents as! [[String:Any]]{
                                    Time.append(time["time"] as! String)
                                }
                            }
                        
                        }
                            DispatchQueue.main.async {
                                self.grid_CollectionView.reloadData()
                            }

                    }
                    }
    }
    
    


    
}

