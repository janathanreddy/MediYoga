//
//  WeeklyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 31/10/20.
//

import UIKit
import Firebase
struct appointment_time {
    var Name: String
    var Date: String
    var appointmenttime: String
    var weekday:String
    init(Name: String,Date: String,appointmenttime: String,weekday:String) {
            self.Name = Name
            self.Date = Date
            self.appointmenttime =  appointmenttime
        self.weekday = weekday
        }
}
class WeeklyViewController: UIViewController{
    let db = Firestore.firestore()
    var TimeAppointment = [appointment_time]()
    var Time:[String] = ["08:00AM - 08:15AM","08:15AM - 08:30AM","08:30AM - 08:45AM","08:45AM - 09:00AM","09:00AM - 09:15AM","09:15AM - 09:30AM","09:30AM - 09:45AM","09:45AM - 10:00AM","10:00AM - 10:15AM","10:15AM - 10:30AM","10:30AM - 10:45AM"]
    var week:[String] = ["Time"]
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
        grid_CollectionView.showsHorizontalScrollIndicator = false
        grid_CollectionView.showsVerticalScrollIndicator = false

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
                TimeAppointment.append(appointment_time(Name: documentData["patient_first_name"] as! String, Date: documentData["appointment_date"] as! String, appointmenttime: documentData["appointment_time"] as! String, weekday: day))
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

                cell.title_Label.text = week[indexPath.row]
                cell.title_Label.textColor = UIColor.black
                cell.title_Label.font = cell.title_Label.font.withSize(16)

                
            }

        else if indexPath.row == 0 && indexPath.section >= 1{
            cell.title_Label.text = Time[indexPath.section]
            cell.title_Label.textColor = UIColor.black
            cell.title_Label.font = cell.title_Label.font.withSize(16)
            cell.title_Label.alpha = 0.6

        }
        else{
            let redvalue = CGFloat(drand48())
            let greenvalue = CGFloat(drand48())
            let bluevalue = CGFloat(drand48())
            
            cell.title_Label.text = "\(indexPath)"
            cell.title_Label.font = cell.title_Label.font.withSize(15)
            cell.title_Label.textColor = UIColor(red: redvalue, green: greenvalue, blue: bluevalue, alpha: 1)
            

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
    
}



