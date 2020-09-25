//
//  PatientDetailsViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 23/09/20.
//

import UIKit

class PatientDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var patientimage: UIImageView!
    
    @IBOutlet weak var patientname: UILabel!
    
    
    @IBOutlet weak var patientage: UILabel!
    
    @IBOutlet weak var patientdiagnosis: UILabel!
    
    @IBOutlet weak var patinetappointtime: UILabel!
    
    @IBOutlet weak var prescriptionbtn: UIButton!
    
    @IBOutlet weak var labrequestbtn: UIButton!
    
    @IBOutlet weak var PatientCollectionView: UICollectionView!
    
    
    
    var name:String = ""
    var age:String = ""
    var time:String = ""
    var cdd:String = ""
    var image:String = ""
    
    
    var Headers:[String] = ["Symtoms","Diagnosis","Prescription","Lab Request"]
    var Description:[[String]] = [["Central LBP - 15 Days","Mid back Pain - 12 Days","Gluteal Pain - 7 Days"],["Left side/Rigt Side","Bilateral","Radiation to arm"],["ACECLO PLUS","BACTRIM DS","CYCLOPAM","GRAVOL","SNEPDOL"],["X-Ray LS SPINE AP & LAT VIEW","X-RAY DORRSAL SPINE AP & LAT VIEW"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)

        patientimage.clipsToBounds = true
        patientimage.layer.cornerRadius = 25
        prescriptionbtn.clipsToBounds = true
        prescriptionbtn.layer.cornerRadius = 10
        labrequestbtn.clipsToBounds = true
        labrequestbtn.layer.cornerRadius = 10
        labrequestbtn.layer.borderWidth = 0.8
        labrequestbtn.layer.borderColor = UIColor.systemBlue.cgColor
        PatientCollectionView.delegate = self
        PatientCollectionView.dataSource = self
        
        patientimage.image = UIImage(named: image)
        patientname.text = name
        patientage.text = age
        patinetappointtime.text = time
        patientage.text = age

    }
    
    @IBAction func Backsegue(_ sender: Any) {

        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func labrequestactionbtn(_ sender: Any) {
        print("labrequestactionbtn")
        
    }
    
    @IBAction func prescriptionactionbtn(_ sender: Any) {
        print("prescriptionactionbtn")

    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Headers.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Description[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PatientCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PatientDetailsCollectionViewCell
        cell.Patientdetails.text = Description[indexPath.section][indexPath.row]

        cell.Patientdetails.preferredMaxLayoutWidth = PatientCollectionView.frame.width
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.systemGray6.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            if let headerLabel = PatientCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PatientHeaderCollectionReusableView", for: indexPath) as? PatientHeaderCollectionReusableView {
                
                headerLabel.HeaderLabel.text = Headers[indexPath.section]
                
                return headerLabel
                
            }
        default:
            return UICollectionReusableView()
        
    }
        return UICollectionReusableView()
}

  
    
    
    
    
}




