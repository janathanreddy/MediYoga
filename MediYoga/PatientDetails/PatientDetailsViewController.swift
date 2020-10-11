//
//  PatientDetailsViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 23/09/20.
//

import UIKit
import FirebaseCore
import FirebaseABTesting
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class PatientDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var casehistory: UIButton!
    
    @IBOutlet weak var patientimage: UIImageView!
    
    @IBOutlet weak var patientname: UILabel!
    
    @IBOutlet weak var patientage: UILabel!
    
    @IBOutlet weak var patientdiagnosis: UILabel!
    
    @IBOutlet weak var patinetappointtime: UILabel!
    
    @IBOutlet weak var prescriptionbtn: UIButton!
    
    @IBOutlet weak var labrequestbtn: UIButton!
    
    @IBOutlet weak var PatientCollectionView: UICollectionView!
    
    
    var patient_id:String = ""
    var name:String = ""
    var age:String = ""
    var time:String = ""
    var cdd:String = ""
    var image:String = ""
//    var Symptom = [PatientSymptoms]()
//    var duration: Int?
//    var type: String = ""
//    var symptoms: String = ""

    let db = Firestore.firestore()

    var Headers:[String] = ["Symtoms","Diagnosis","Prescription","Lab Request"]
    var Description = [[String](),[String](),["ACECLO PLUS","BACTRIM DS","CYCLOPAM","GRAVEL","SNEPDOL"],["X-RAY LS SPINE AP & LAT VIEW","X-RAY DORSAL SPINE P & LAT VIEW"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        casehistory.layer.cornerRadius = 10
        casehistory.clipsToBounds = true
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
        
        db.collection("appointments").whereField("patient_id", isEqualTo: patient_id).getDocuments(){ [self] (querySnapshot, error) in
                            if  error == nil && querySnapshot != nil {

                            for document in querySnapshot!.documents {
                                
                            let documentData = document.data()
                            let patient_symptoms = documentData["patient_symptoms"] as! [[String:Any]]
                            for Symptoms in patient_symptoms{
                            
                                Description[0].append("\(Symptoms["symptoms"] as! String) - \(Symptoms["duration"] as! String)\(Symptoms["type"] as! String)")
                                
                                }
                                let patient_diagnosis = documentData["diagnosis"] as! [[String:Any]]

                                for diagnosis in patient_diagnosis{
                                    
                                    Description[1].append("\(diagnosis["diagnosis_name"] as! String)")
                                    
                                }
                    }
                        DispatchQueue.main.async {
                            self.PatientCollectionView.reloadData()
                        }
                }
            }

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





