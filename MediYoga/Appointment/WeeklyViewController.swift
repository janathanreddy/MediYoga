//
//  WeeklyViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 31/10/20.
//

import UIKit
import SpreadsheetView

class WeeklyViewController: UIViewController,SpreadsheetViewDataSource,SpreadsheetViewDelegate {
    
   
    

    private let spreadsheetView = SpreadsheetView()
    let Data:[String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    @IBOutlet weak var WeeklyBtn: UIButton!
    
    @IBOutlet weak var dropDown: UIButton!
    
    @IBOutlet weak var DropDownView: UIView!
    
    @IBOutlet weak var MonthlyBtn: UIButton!
    
    @IBOutlet weak var Todaybtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spreadsheetView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .systemGray6)
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        view.addSubview(spreadsheetView)
        spreadsheetView.showsVerticalScrollIndicator = false
        spreadsheetView.showsHorizontalScrollIndicator = false
        
    }
    override func viewDidLayoutSubviews() {
        spreadsheetView.frame = CGRect(x: 0, y: 112, width: 414, height: 682)
    }
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return Data.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return Data.count
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 200
 
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 100
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let Cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: MyCell.identifier, for: indexPath) as! MyCell
        if indexPath.row == 0 && indexPath.section == 0{
            Cell.setup(with: "Time")
        }else if indexPath.row == 0 {
            Cell.setup(with: Data[indexPath.row])

        }else if indexPath.row == 1 && indexPath.section == 0{
            Cell.setup(with: "9.30AM - 9.45AM")
        }
        else{
            Cell.setup(with: "Patient Appointment")
        }
        return Cell
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
    
}

class MyCell: Cell{
    static let identifier = "MyCell"
    private let label =  UILabel()
    public func setup(with text: String){
        label.text = text
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
