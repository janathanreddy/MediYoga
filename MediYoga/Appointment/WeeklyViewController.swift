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
    var TimeAppointment = [appointment_time]()
    var week = [String]()
    var Time = [String]()
    var name = [String]()
    var weekday = [String]()
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
                Time.append(documentData["appointment_time"] as! String)
                name.append(documentData["patient_first_name"] as! String)
                print(name)
                print(Time)
            TimeAppointment.append(appointment_time(Name: "\(documentData["patient_first_name"] as! String) \(documentData["patient_last_name"] as! String)", Date: documentData["appointment_date"] as! String, Time: documentData["appointment_time"] as! String, check: true))
                print("TimeAppointment : \(documentData["appointment_time"] as! String) \(Time.count)")
                print("Name : \(documentData["patient_first_name"] as! String) \(Time.count)")
                let isoDate = documentData["appointment_date"] as! String

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_IN") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let date = dateFormatter.date(from:isoDate)
                let dayformate = DateFormatter()
                dayformate.dateFormat = "dd,EEE"
                var day = dayformate.string(from: date!)
                weekday.append(day)
                print(TimeAppointment)
                
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0{
            cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .gray

            if indexPath == [0,0]{
                
                cell.title_Label.text = "Time"
                
            }else{
                cell.title_Label.text = week[indexPath.row]
                
            }
            
        }
        else if indexPath.row == 0{

            if indexPath == [0,0]{
                
                cell.title_Label.text = "Time"

                
            }else{
                cell.title_Label.text = Time[indexPath.row]
                
            }

        }

        else{
            
            cell.title_Label.text = name[indexPath.row]

        }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white

        return cell
    }
    
    
}
class appointment_time {
    let Name: String
    let Date: String
    let Time: String
    let check: Bool
    init(Name: String,Date: String,Time: String
,check: Bool) {
        self.Name = Name
        self.Date = Date
        self.Time =  Time
        self.check = check
    }
}

