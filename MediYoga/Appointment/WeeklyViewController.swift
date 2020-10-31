//
//  WeeklyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 31/10/20.
//

import UIKit
import SpreadsheetView
import Firebase

class WeeklyViewController: UIViewController,SpreadsheetViewDataSource,SpreadsheetViewDelegate {
//    var header = [String]()
//    var data = [[String]]()
    let db = Firestore.firestore()
    var TimeAppointment = [appointment_time]()
    private let spreadsheetView = SpreadsheetView()
    let header:[String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    let Time:[[String]] = [["9:20AM - 9:30AM","9:30AM - 9:40AM","9:40AM - 9:50AM","9:50AM - 10:00AM","10:00AM - 10:10AM","10:10AM - 10:20AM"]]
    @IBOutlet weak var WeeklyBtn: UIButton!
    
    @IBOutlet weak var dropDown: UIButton!
    
    @IBOutlet weak var DropDownView: UIView!
    
    @IBOutlet weak var MonthlyBtn: UIButton!
    
    @IBOutlet weak var Todaybtn: UIButton!
    
    @IBOutlet weak var WeeklyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DoctorAppointments()
        spreadsheetView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.identifier)
        spreadsheetView.register(Column.self, forCellWithReuseIdentifier: Column.identifier)

        spreadsheetView.gridStyle = .solid(width: 0.8, color: .systemGray6)
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        WeeklyView.addSubview(spreadsheetView)
        spreadsheetView.showsVerticalScrollIndicator = false
        spreadsheetView.showsHorizontalScrollIndicator = false

        
    }
    override func viewDidLayoutSubviews() {
        spreadsheetView.frame = CGRect(x: 0, y: 0, width: 414, height: 644)
    }
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return header.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return Time.count
    }
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 180
 
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 90
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
//        let Cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MyCell.identifier, for: indexPath) as! MyCell
//        if indexPath.row == 0 && indexPath.section == 0{
//            Cell.setup(with: "Time")
//        }else if (indexPath.row == 0) && (indexPath.section == header.count){
//            Cell.setup(with: header[indexPath.row])
//        }
//        else{
//
//            Cell.setup(with: "Patient Appointment")
//        }
        
        if case 0 = indexPath.row {

            let Cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: Column.self), for: indexPath) as! Column

//            cell.label.text = header[indexPath.column]
            Cell.setup(with: header[indexPath.column])



            Cell.setNeedsLayout()



            return Cell

        } else {

            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: MyCell.self), for: indexPath) as! MyCell

            if indexPath.row < Time.count+1{

                cell.setup(with: Time[indexPath.row][indexPath.column])
            }
            

            return cell

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
                print("documentData : \(documentData["patient_first_name"] as! String) \(documentData["patient_last_name"] as! String),\(documentData["appointment_date"] as! String),\(documentData["appointment_time"] as! String)")
            self.TimeAppointment.append(appointment_time(Name: "\(documentData["patient_first_name"] as! String) \(documentData["patient_last_name"] as! String)", Date: documentData["appointment_date"] as! String, Time: documentData["appointment_time"] as! String, check: true))
                print("TimeAppointment : \(TimeAppointment)")

    }
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
        }
        
}
}
    }
  
    
    
}

class MyCell: Cell{
    static let identifier = "MyCell"
    private let label =  UILabel()
    public func setup(with text: String){
        label.text = text
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
    class Column: Cell{
        static let identifier = "Column"
        private let label =  UILabel()
        public func setup(with text: String){
            label.text = text
            label.font = label.font.withSize(14)
            label.textAlignment = .center
            contentView.addSubview(label)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            label.frame = contentView.bounds
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
