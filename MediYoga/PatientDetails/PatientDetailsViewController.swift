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
    let db = Firestore.firestore()
    var CurrentDate:String = ""
    var Headers:[String] = ["Symtoms","Diagnosis","Prescription","Lab Request"]
    var Description = [[String](),[String](),[String](),[String]()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date()
        print("patient_id: \(patient_id)")
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
        
        Symptoms_Diagnosis()
        prescription()
        lab_requests()
        
    }
    
    @IBAction func Backsegue(_ sender: Any) {

        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func labrequestactionbtn(_ sender: Any) {
        
        print("labrequestactionbtn")
        
    }
    
    @IBAction func prescriptionactionbtn(_ sender: Any) {
        print("patient_id from Details : \(patient_id) ")
        performSegue(withIdentifier: "Prescription", sender: self)
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
        
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layer.cornerRadius = 8
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Prescription"
        {
            let Prescription:PriscriptionViewController = segue.destination as! PriscriptionViewController
            Prescription.patient_id = patient_id
            
        }
    }
    
    func Symptoms_Diagnosis(){
        
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
    
    func prescription(){
        
        
        db.collection("patient_prescriptions").document(patient_id).getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    for documents in document.value as! [[String:Any]]{
                        let time_Stamp = documents["date"] as! Timestamp
                        let timeStamp = time_Stamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM dd,yyyy"
                        let ChatTime = dateFormatter.string(from: timeStamp)
                        if ChatTime == CurrentDate {
                        for DrugList in documents["drugs"] as! [[String:Any]]{
                            Description[2].append(DrugList["drug_name"] as! String)}
                        }
                    }
                  }
                DispatchQueue.main.async {
                    self.PatientCollectionView.reloadData()
                }

              }
        }
        
    }
    
    func lab_requests(){
        
        
        db.collection("patient_lab_requests").document(patient_id).getDocument() { [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                for document in snapshot!.data()! as [String:Any] {
                    for documents in document.value as! [[String:Any]]{
                        
                        let time_Stamp = documents["date"] as! Timestamp
                        let timeStamp = time_Stamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM dd,yyyy"
                        let ChatTime = dateFormatter.string(from: timeStamp)
                        if ChatTime == CurrentDate {
                        for requests in documents["requests"] as! [Any]{
                            
                            Description[3].append(requests as! String)
                            
                        }
                        
                    }
                }
                DispatchQueue.main.async {
                    self.PatientCollectionView.reloadData()
                }

              }
        }
        
    }
    }
    
    
    func date(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        CurrentDate = dateFormatter.string(from: date)
        
        
    }
}






