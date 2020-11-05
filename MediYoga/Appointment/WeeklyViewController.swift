//
//  WeeklyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 31/10/20.
//

import UIKit
import Firebase

class WeeklyViewController: UIViewController{
   
    let db = Firestore.firestore()
    var Time:[String] = [" "]
    var week:[String] = ["Time"]
    var weeklyname:[String] = [" "]
    var Timely:[String] = [" "]
    var week_days:[String] = [" "]
    var Sunday = [String: String]()
    var Monday = [String: String]()
    var Tuesday = [String: String]()
    var Wednesday = [String: String]()
    var Thursday = [String: String]()
    var Friday = [String: String]()
    var Saturday = [String: String]()


    
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
    @IBOutlet weak var WeeklyBtn: UIButton!
    
    @IBOutlet weak var dropDown: UIButton!
    
    @IBOutlet weak var DropDownView: UIView!
    
    @IBOutlet weak var MonthlyBtn: UIButton!
    
    @IBOutlet weak var Todaybtn: UIButton!
    
    @IBOutlet weak var WeeklyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DoctorAppointments()
        currentweekdays()
        Weeek_Day()
        grid_CollectionView.showsHorizontalScrollIndicator = false
        grid_CollectionView.showsVerticalScrollIndicator = false
        self.grid_CollectionView.reloadData()


    }
    func currentweekdays(){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
    let formatter = DateFormatter()
    formatter.dateFormat = "dd,EEE"
    for date in days {
        week.append(formatter.string(from: date))
    }

    }
    @IBAction func WeeklyAct(_ sender: Any) {
        WeeklyBtn.isSelected = !WeeklyBtn.isSelected
        dropDown.isSelected = !dropDown.isSelected
        
        if WeeklyBtn.isSelected == true || dropDown.isSelected == true{
            
            DropDownView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.dropDown.imageView!.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
            })

            
        }
        else{
            DropDownView.isHidden = true
        }
        
        
    }
    
    @IBAction func TodayAct(_ sender: Any) {
        DropDownView.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
              self.dropDown.imageView!.transform = CGAffineTransform.identity
        })
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func MontlyAct(_ sender: Any) {
        DropDownView.isHidden = true
        WeeklyBtn.setTitle("Monthly", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
              self.dropDown.imageView!.transform = CGAffineTransform.identity
        })

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
                if String(day.dropFirst(3)) == "Sun"{
                    Sunday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Sunday : \(Sunday)")
                
                }else if String(day.dropFirst(3)) == "Mon"{
                    Monday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Monday : \(Monday)")
                
                }else if String(day.dropFirst(3)) == "Tue"{
                    Tuesday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Tuesday : \(Tuesday)")
                
                }else if String(day.dropFirst(3)) == "Wed"{
                    Wednesday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Wednesday : \(Wednesday)")
                
                }else if String(day.dropFirst(3)) == "Thu"{
                    Thursday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Thursday : \(Thursday)")
                
                }else if String(day.dropFirst(3)) == "Fri"{
                    Friday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Friday : \(Friday)")
                
                }else if String(day.dropFirst(3)) == "Sat"{
                    Saturday.updateValue("\(documentData["patient_first_name"] as! String)", forKey: "\(documentData["appointment_time"] as! String)")
                    print("Saturday : \(Saturday)")
                
                }
                weeklyname.append(documentData["patient_first_name"] as! String)
                Timely.append(documentData["appointment_time"] as! String)
                week_days.append(day)

    }

        DispatchQueue.main.async {
            self.grid_CollectionView.reloadData()
        }
        
}
}
    }

    
}
extension WeeklyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: 100, height: 50)
        }
        return CGSize(width: 100, height: 100)
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
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        if indexPath.section == 0{

                cell.title_Label.text = week[indexPath.row]
                cell.title_Label.textColor = UIColor.black
                cell.title_Label.font = cell.title_Label.font.withSize(16)

            }

        else if indexPath.item == 0 && indexPath.section >= 1{
            cell.title_Label.text = Time[indexPath.section]
            cell.title_Label.textColor = UIColor.black
            cell.title_Label.font = cell.title_Label.font.withSize(16)
            cell.title_Label.alpha = 0.6

        }
        else if indexPath.item == 1 && indexPath.section >= 1 {
            
            if Sunday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Sunday{
                    print("key-1 \(key) : value-1 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        
        else if indexPath.item == 2 && indexPath.section >= 1 {
            
            if Monday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Monday{
                    print("key-2 \(key) : value-2 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        else if indexPath.item == 3 && indexPath.section >= 1 {
            
            if Tuesday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Tuesday{
                    print("key-3 \(key) : value-3 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        else if indexPath.item == 4 && indexPath.section >= 1 {
            
            if Wednesday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Wednesday{
                    print("key-4 \(key) : value-4 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        else if indexPath.item == 5 && indexPath.section >= 1 {
            
            if Thursday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Thursday{
                    print("key-5 \(key) : value-5 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        else if indexPath.item == 6 && indexPath.section >= 1 {
            
            if Friday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Friday{
                    print("key-6 \(key) : value-6 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        else if indexPath.item == 7 && indexPath.section >= 1 {
            
            if Saturday.isEmpty != false{
                cell.title_Label.text = " "
            }
            else{
                for (key,value) in Saturday{
                    print("key-7 \(key) : value-7 \(value)")
                    if Time[indexPath.section] == key {
                        cell.title_Label.text = value
                        cell.title_Label.font = cell.title_Label.font.withSize(15)
                }

                }
            }
            
        }
        
        else{
            cell.title_Label.text = " "
    }


        cell.layer.borderWidth = 0.8
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        if indexPath.section == 0 {
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .systemTeal : .white
        }else {
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .white : .white

        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section): \(Time[indexPath.section]),\(indexPath.row): \(week[indexPath.row])")
    }
    
    
    func Weeek_Day(){
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
                    }
                    }
    }
    
    
}



