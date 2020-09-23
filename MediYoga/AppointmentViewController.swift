//
//  AppointmentViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class AppointmentViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var BlurEffect: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var NotesView: UIView!
    
    @IBOutlet weak var TextViewField: UITextView!
    
//    private var search = UISearchController(searchResultsController: nil)
    var image:[String] = ["31","32","33","34","35","36","37","38","39","40"]
    var age:[String] = ["34","32","36","40","45","40","43","28","22","41"]
    var name:[String] = ["Johnson","Maclarn","Lee","Chuva","Roamanson","Jonny","Anderson","BikiDev","Assik","Kaamil"]
    var ccd:[String] = ["CCD","CCD/LDD","LDD","CDD","LDD","CDD","CCD/LDD","LDD","CDD","LDD"]
    var time:[String] = ["8:40AM-8.50AM","8:50AM-9:00AM","9:00AM-9:10AM","9:10AM-9:20AM","9:20AM-9:30AM","9:30AM-9:40AM","9:40AM-9:50AM","9:50AM-10:00AM","10:00AM-10:10AM","10:10AM-10:20AM"]
    var at:[String] = ["AT.png","FC.png","old.png","MT.png","N.png","AT.png","FC.png","old.png","MT.png","N.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        Search_Bar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        TextViewField.layer.borderColor = UIColor.systemGray.cgColor
        TextViewField.layer.borderWidth = 0.8

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
//           navigationItem.hidesSearchBarWhenScrolling = true
       }
    
//    func Search_Bar(){
//        search.searchBar.delegate = self
//        search.searchBar.sizeToFit()
//        search.obscuresBackgroundDuringPresentation = false
//        search.hidesNavigationBarDuringPresentation = true
//        self.definesPresentationContext = true
//        search.searchBar.placeholder = "Search Appointment"
//        self.navigationItem.searchController = search
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ApplicationTableViewCell
        cell.appointmentimage.image = UIImage(named: image[indexPath.row])
        cell.NameField.text = name[indexPath.row]
        cell.AgeField.text = age[indexPath.row]
        cell.TimeField.text = time[indexPath.row]
        cell.ccdField.text = ccd[indexPath.row]
        cell.statusField.image = UIImage(named: at[indexPath.row])
//        cell.delegate = self
//        cell.index = indexPath
        return cell
        
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
        
        let vc = storyboard?.instantiateViewController(identifier: "PatientDetailsViewController") as! PatientDetailsViewController
            
        vc.name = name[indexPath.row]
        vc.age = age[indexPath.row]
        vc.image = image[indexPath.row]
        vc.cdd = ccd[indexPath.row]
        vc.time = time[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        print(indexPath.row)
//       return infoViewController.deselectRow(at: indexPath, animated: true)

        
        

    }
    @IBAction func CancelNotes(_ sender: Any) {
        animatedismiss(desiredView: BlurEffect)
        animatedismiss(desiredView: NotesView)
    }
    
    @IBAction func OkNotes(_ sender: Any) {
    }
}

//extension UIViewController: TableViewCellDelegate {
//  func didSelect(_ cell: UITableViewCell, _ button: UIButton) {
//    let indexPath = IndexPath(row: 0, section: 0)
//    let cell = tableView.cellForRow(at: indexPath)
//    let tag = button.tag
//  }
//}
