//
//  ComChatViewController.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit
import Firebase
import AVFoundation
import ImageIO
import Nuke


struct messagedata {
    
    var text : String
    var time : String
    var isFirstUser : Bool
    var sendimagebool : Bool
    var sentimage:UIImage?
    var sentlabel:String
    var url:String?
    var ReceiverImageBool: Bool
    var doctoraudio: Bool
    var patientaudio: Bool
    var DoctorRecordLabel: String
    var date:Date
    
}

extension Date {
    static func dateFromCustomstring(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func ReduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: "\(day)/\(month)/\(year)") ?? Date()
    }
}



class ComChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIImagePickerControllerDelegate &  UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate, Doctorplay, PatientPlay,DoctorImage,PatientImage {
    

    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    var meterTimer: Timer!
    var soundFileURL: URL!
    var Patient_Id:String = ""
    var Image_url:String?
    
    var resizedImageProcessors: [ImageProcessing] {
      let imageSize = CGSize(width: 240, height: 111)
      return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
    }
    @IBOutlet weak var StopButton: UIButton!

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MicBtn: UIButton!
    @IBOutlet weak var SelectedImageView: UIImageView!
    let db = Firestore.firestore()
    @IBOutlet weak var ButtomSpace: NSLayoutConstraint!
    fileprivate let application = UIApplication.shared
    var message = [messagedata]()
    @IBOutlet weak var camerabutton: UIButton!
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var imagename:String = ""
    var GroupName:String = ""
    var UserId:String = ""
    var dateupdate: String?
    var timeupdate: String?
    var documentID: String = ""
    var DoctorId: String = ""
    var DoctorName: String = ""
    var playerDuration: String = ""
    var indexpathrow:Int?
    var audio_url:String?
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MessageLabel: UILabel!
    var ChatMessage = [[messagedata]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityIndicator.alpha = 1
        ActivityIndicator.startAnimating()

        tableView.showsVerticalScrollIndicator = false
        askForNotifications()
        print("UserId: \(DoctorId) , documentID: \(documentID)")
        tableView.delegate = self
        tableView.dataSource = self
        profileimage.layer.cornerRadius = 25
        profileimage.clipsToBounds = true
        self.picker.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        TextField.layer.cornerRadius = 13.0
        TextField.layer.borderWidth = 1.0
        TextField.layer.borderColor = UIColor.systemGray5.cgColor
        profileimage.image = UIImage(named: imagename)
        MessageLabel.text = GroupName
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        tableView.register(UINib(nibName: "ComImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ComImageTableViewCell")
        
        tableView.register(UINib(nibName:"ComChatReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ComChatReceiverTableViewCell")
        
        tableView.register(UINib(nibName: "ComChatReceiveimageTableViewCell", bundle: nil), forCellReuseIdentifier: "ComChatReceiveimageTableViewCell")
        
        tableView.register(UINib(nibName: "AudioFileDoctorTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioFileDoctorTableViewCell")
        
        tableView.register(UINib(nibName: "AudioFilePatientTableViewCell", bundle: nil), forCellReuseIdentifier: "AudioFilePatientTableViewCell")
        messages()
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    @objc func didTapView(){
      self.view.endEditing(true)
    }

    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.ButtomSpace.constant = keyBoardHeight
                var contentInset:UIEdgeInsets = self.tableView.contentInset
                self.tableView.contentInset = contentInset
                let section = self.ChatMessage.count - 1
                let row = self.ChatMessage[section].count - 1
                if ChatMessage.count != 0{
                    tableView.scrollToRow(at: IndexPath(row: row , section: section), at: .top, animated: true)
                }


                contentInset.bottom = keyBoardRect!.height
                _ = NSIndexPath(row: 1, section: 0)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    @objc func keyBoardWillHide(notification: Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset

        self.ButtomSpace.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .tertiarySystemFill
            textColor = .black
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = ChatMessage[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            print("dateString : \(dateString)")
            let label = DateHeaderLabel()
            label.text = dateString
            
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
            
        }
        return nil
    }
    func date(){
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        dateupdate = formatter.string(from: currentDateTime)
        
    }
    func time(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        timeupdate = formatter.string(from: currentDateTime)
 
    }
    @IBAction func backsegue(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CallBtnAction(_ sender: UIButton) {
        if let phoneURL = URL(string: "tel://9003660005"){
            if application.canOpenURL(phoneURL){
                application.open(phoneURL,options: [:],completionHandler: nil)
            }
        }
    }
    
    @IBAction func mic(_ sender: Any) {
        
        print("\(#function)")
        print("Button Tapped")
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
//            MicBtn.tintColor = UIColor.systemGreen
//            playButton.isEnabled = false
            StopButton.isEnabled = true
            StopButton.isHidden = false
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recorder.pause()
//            MicBtn.setTitle("Continue", for: .normal)
            MicBtn.imageView?.image = UIImage(systemName: "pause.cicle.fill")
            
        } else {
            print("recording")
//            MicBtn.setTitle("Pause", for: .normal)
            MicBtn.imageView?.image = UIImage(systemName: "mic.circle.fill")
//            playButton.isEnabled = false
//            stopButton.isEnabled = true
            recordWithPermission(false)
        }
        
        
    }
    
    
    
    func recordWithPermission(_ setup: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target: self,
                                                           selector: #selector(self.updateAudioMeter(_:)),
                                                           userInfo: nil,
                                                           repeats: true)
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission == .denied {
            print("permission denied")
        }
    }
    
    @objc func updateAudioMeter(_ timer: Timer) {
        
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
//                statusLabel.text = s
                recorder.updateMeters()
            }
        }
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
     
    func setupRecorder() {
        print("\(#function)")
        
        let currentFileName = "audio.m4a"
        print("currentFileName : \(currentFileName)")
        let data = Data()

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")


        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }


        tableView.reloadData()

    }
    
    @IBAction func CameraAction(_ sender: AnyObject) {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        present(picker,animated: true,completion: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
             tableView.reloadData()
         }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        date()
        time()
        
        if let images = info[UIImagePickerController.InfoKey.originalImage] {
            
            SelectedImageView.image = images as! UIImage
            ChatMessage.append([messagedata(text: TextField.text!, time: timeupdate!, isFirstUser: true, sendimagebool: true, sentimage: images as? UIImage , sentlabel: TextField.text!, url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false,DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(dateupdate)"))])

                let randomid = UUID.init().uuidString
                let uploadref = Storage.storage().reference(withPath: "chat/euO4eHLyxXKDVmLCpNsO/\(randomid).jpg")
            guard let imagedata = self.SelectedImageView?.image?.jpegData(compressionQuality: 0.3) else {
                    return
                }
                let uploadMetadata = StorageMetadata.init()
                uploadref.putData(imagedata, metadata: uploadMetadata){(downloadMetaData,error) in
                    if error != nil{
                        print("error path meta uploaddata 1\(error?.localizedDescription)")
                    return
                    }
                    print("\(String(describing: downloadMetaData))")

                    uploadref.downloadURL(completion:  { [self] (url,error) in
                        if error != nil
                        {
                            print("doewloadurl error msg \(error?.localizedDescription)")
                            return
                        }
                        if url != nil {
                            let url = url!.absoluteString
                            db.collection("patient_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": DoctorId,"sender_name": DoctorName,"text": "image","time_stamp": FieldValue.serverTimestamp(),"type": 1,"content_url": url])
                        }
                })
                }
            
            
            
            TextField.text = ""
            tableView.reloadData()
            let section = ChatMessage.count-1
            let row = ChatMessage[section].count-1
            tableView.scrollToRow(at: IndexPath(row:ChatMessage[section].count-1, section: ChatMessage.count-1), at: .top, animated: true)


                } else {
                    print("Check Image Code Error...!!!")
                }
                
                self.dismiss(animated: true, completion: nil)
         }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessage[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ChatMessage.count != 0{
            
            ActivityIndicator.stopAnimating()
            ActivityIndicator.alpha = 0

           
        }


        if ChatMessage[indexPath.section][indexPath.row].isFirstUser == false && ChatMessage[indexPath.section][indexPath.row].ReceiverImageBool == false && ChatMessage[indexPath.section][indexPath.row].patientaudio == false{
            let ComChatReceiverTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComChatReceiverTableViewCell", for: indexPath) as! ComChatReceiverTableViewCell
            ComChatReceiverTableViewCell.ReceiverView.layer.cornerRadius = 16
            ComChatReceiverTableViewCell.ReceiverLabel.text = ChatMessage[indexPath.section][indexPath.row].text
            ComChatReceiverTableViewCell.ReadCheck.text = "unread"
            ComChatReceiverTableViewCell.ReceiverTime.text = ChatMessage[indexPath.section][indexPath.row].time

            return ComChatReceiverTableViewCell
        }
       
        else if ChatMessage[indexPath.section][indexPath.row].sendimagebool == true{
            if ChatMessage[indexPath.section][indexPath.row].sentimage != nil{
            let ComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComImageTableViewCell", for: indexPath) as! ComImageTableViewCell
            ComImageTableViewCell.CellDelegate = self
            ComImageTableViewCell.index = indexPath
            ComImageTableViewCell.sendimageview.layer.cornerRadius = 10
            ComImageTableViewCell.sendimageview.clipsToBounds = true
            ComImageTableViewCell.sendimage.layer.cornerRadius = 10
            ComImageTableViewCell.sendimage.clipsToBounds = true
            ComImageTableViewCell.ImageTime.text = ChatMessage[indexPath.section][indexPath.row].time
            ComImageTableViewCell.sendimage.image = ChatMessage[indexPath.section][indexPath.row].sentimage

                if ChatMessage[indexPath.section][indexPath.row].sentlabel == "" {
                    ComImageTableViewCell.sendlabel.isHidden = true
                }else{
                    ComImageTableViewCell.sendlabel.isHidden = false
                    ComImageTableViewCell.sendlabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
                }

                return ComImageTableViewCell
            }
            let ComImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComImageTableViewCell", for: indexPath) as! ComImageTableViewCell
            ComImageTableViewCell.sendimageview.layer.cornerRadius = 10
            ComImageTableViewCell.sendimageview.clipsToBounds = true
            ComImageTableViewCell.CellDelegate = self
            ComImageTableViewCell.index = indexPath
            ComImageTableViewCell.sendimage.layer.cornerRadius = 10
            ComImageTableViewCell.sendimage.clipsToBounds = true
            ComImageTableViewCell.ImageTime.text = ChatMessage[indexPath.section][indexPath.row].time
            let user = ChatMessage[indexPath.section][indexPath.row]
            if let profileImageUrl = user.url {
//                Nuke.loadImage(with: url, into: cell.imageView)
                let image_Compress = URL(string: profileImageUrl)

                let request = ImageRequest(url: image_Compress!,processors: resizedImageProcessors)

                Nuke.loadImage(with: request as! ImageRequestConvertible, into: ComImageTableViewCell.sendimage)

//                ComImageTableViewCell.sendimage.LoadImageUsingCacheWithUrlString(profileImageUrl)
            }
            if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                ComImageTableViewCell.sendlabel.isHidden = true
            }else{
                ComImageTableViewCell.sendlabel.isHidden = false
                ComImageTableViewCell.sendlabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
            }
            ActivityIndicator.stopAnimating()
            ActivityIndicator.alpha = 0

            return ComImageTableViewCell
        }
        else if ChatMessage[indexPath.section][indexPath.row].ReceiverImageBool == true && ChatMessage[indexPath.section][indexPath.row].isFirstUser == false{
            let ComChatReceiveimageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ComChatReceiveimageTableViewCell", for: indexPath) as! ComChatReceiveimageTableViewCell
            ComChatReceiveimageTableViewCell.CellDelegate = self
            ComChatReceiveimageTableViewCell.index = indexPath
            ComChatReceiveimageTableViewCell.ReceiverView.layer.cornerRadius = 10
            ComChatReceiveimageTableViewCell.ReceiverView.clipsToBounds = true
            ComChatReceiveimageTableViewCell.ReceiverImage.layer.cornerRadius = 10
            ComChatReceiveimageTableViewCell.ReceiverImage.clipsToBounds = true
            ComChatReceiveimageTableViewCell.ReceiverTime.text = ChatMessage[indexPath.section][indexPath.row].time
            let user = ChatMessage[indexPath.section][indexPath.row]
            if let profileImageUrl = user.url {
                let image_Compress = URL(string: profileImageUrl)
                let request = ImageRequest(url: image_Compress!,processors: resizedImageProcessors)

                Nuke.loadImage(with: request as! ImageRequestConvertible, into: ComChatReceiveimageTableViewCell.ReceiverImage)

//                ComChatReceiveimageTableViewCell.ReceiverImage.LoadImageUsingCacheWithUrlString(profileImageUrl)
            }

            if ChatMessage[indexPath.section][indexPath.row].sentlabel == ""{
                ComChatReceiveimageTableViewCell.ReceiverImageLabel.isHidden = true
            }else{
                ComChatReceiveimageTableViewCell.ReceiverImageLabel.isHidden = false
                ComChatReceiveimageTableViewCell.ReceiverImageLabel.text = ChatMessage[indexPath.section][indexPath.row].sentlabel
            }
            ActivityIndicator.stopAnimating()
            ActivityIndicator.alpha = 0

            return ComChatReceiveimageTableViewCell
        }
        else if ChatMessage[indexPath.section][indexPath.row].doctoraudio == true && ChatMessage[indexPath.section][indexPath.row].isFirstUser == true &&  ChatMessage[indexPath.section][indexPath.row].patientaudio == false {
            let AudioFileDoctorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AudioFileDoctorTableViewCell", for: indexPath) as! AudioFileDoctorTableViewCell

            AudioFileDoctorTableViewCell.recordView.layer.cornerRadius = 10
            AudioFileDoctorTableViewCell.recordView.clipsToBounds = true
            AudioFileDoctorTableViewCell.recordLabel.text = "Dotor Audio Record"
            AudioFileDoctorTableViewCell.celldelegate = self
            AudioFileDoctorTableViewCell.index = indexPath



            return AudioFileDoctorTableViewCell
            
        }
        
        else if ChatMessage[indexPath.section][indexPath.row].patientaudio == true && ChatMessage[indexPath.section][indexPath.row].isFirstUser == false && ChatMessage[indexPath.section][indexPath.row].doctoraudio == false{
            
            
            let AudioFilePatientTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AudioFilePatientTableViewCell", for: indexPath) as! AudioFilePatientTableViewCell
            
            AudioFilePatientTableViewCell.recordView.layer.cornerRadius = 10
            AudioFilePatientTableViewCell.recordView.clipsToBounds = true
            AudioFilePatientTableViewCell.recordlabel.text = "Patient Audio Record"
            
            AudioFilePatientTableViewCell.celldelegate = self
            AudioFilePatientTableViewCell.index = indexPath


            return AudioFilePatientTableViewCell
            
        }
        
            else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_1", for: indexPath) as! ComChatTableViewCell
            cell.messageBackgroundView.layer.cornerRadius = 16
            cell.CellMessageLabel.text = ChatMessage[indexPath.section][indexPath.row].text
                   cell.ReadCheckLabel.text = "unread"
            cell.timeLabel.text = ChatMessage[indexPath.section][indexPath.row].time

                       return cell
        }

return UITableViewCell()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ChatMessage.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        date()
        time()
        let textFromField:String = TextField.text!
        if TextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "", message: "Message TextField Empty", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )

        }
        else{
            
            db.collection("patient_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": DoctorId,"sender_name": DoctorName,"text": textFromField,"time_stamp": FieldValue.serverTimestamp(),"type": 0])
            let newDocument = db.collection("patient_chat").document(documentID)
            newDocument.updateData(["last_message": textFromField,"last_message_time": FieldValue.serverTimestamp()])

            ChatMessage.append([messagedata(text: textFromField,time: timeupdate!,isFirstUser: true, sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(dateupdate)"))])
            let section = ChatMessage.count-1
            let row = ChatMessage[section].count-1
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row:ChatMessage[section].count-1, section: ChatMessage.count-1), at: .top, animated: true)

            TextField.text = ""
            
        }
       return true
    }
   
    func messages(){
            
            db.collection("patient_chat").document(documentID).collection("messages").order(by: "time_stamp").getDocuments(){ [self] (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in snapshot!.documents {
                    
                      let docId = document.documentID
                      let documentData = document.data()
                      let time_Stamp = documentData["time_stamp"] as! Timestamp
                      let timeStamp = time_Stamp.dateValue()
                      let dateFormatter = DateFormatter()
                      dateFormatter.amSymbol = "AM"
                      dateFormatter.pmSymbol = "PM"
                      dateFormatter.dateFormat = "hh:mm a"
                      let ChatTime = dateFormatter.string(from: timeStamp)
                      let sender_id = documentData["sender_id"] as! String
                      let dateFormatter_1 = DateFormatter()
                      dateFormatter_1.dateFormat = "dd MMMM yyyy"
                      let SecDate = dateFormatter_1.string(from: timeStamp)
                        print("Date : \(SecDate)")
                        
                        if sender_id == DoctorId {
                            if documentData["type"] as! Int == 0{
                                
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(SecDate)")))

                                
                            }
                            else if documentData["type"] as! Int == 1{
                
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: true, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(SecDate)")))

                                
                            }
                            
                            else if documentData["type"] as! Int == 3{
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: true,sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: true,patientaudio: false, DoctorRecordLabel: "Audio Record", date: Date.dateFromCustomString(customString: "\(SecDate)")))
                            }

                        }
                        else if sender_id != DoctorId{
    //                        print("Patient : \(documentData["text"] as! String)")
                            if documentData["type"] as! Int == 0{
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: "",ReceiverImageBool: false,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(SecDate)")))
                            }
                            else if documentData["type"] as! Int == 1{
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: true,doctoraudio: false,patientaudio: false, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(SecDate)")))


                            }
                            else if documentData["type"] as! Int == 3{
                                message.append(messagedata(text: documentData["text"] as! String,time: ChatTime,isFirstUser: false, sendimagebool: false, sentlabel: "", url: documentData["content_url"] as! String,ReceiverImageBool: false,doctoraudio: false,patientaudio: true, DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(SecDate)")))


                            }
                            

                        }
                        
                        
                        
                    }
                    let Grouping_Message = Dictionary(grouping: message, by: {(element) -> Date in
                        return element.date
                    })
                    print("Dictionary : \(Dictionary(grouping: message, by: { $0.date }))")

                    print("Grouping_Message : \(Grouping_Message)")
                    let keys = Grouping_Message.keys.sorted()
                    print("keys : \(keys)")
                    keys.forEach { (key) in
                        let values = Grouping_Message[key]
                        ChatMessage.append(values ?? [])
                        print("chatMessages : \(values)")
                    }
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }

                }
                
                
          }
        
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
    }

    
    
    func play(_ url: URL) {
        print("playing \(url)")

        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 7.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
            print("AVAudioPlayer init failed")
        }
        
    }
    
 
    @IBAction func stopbtn(_ sender: Any) {
        time()
        date()
        print("\(#function)")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        MicBtn.setTitle("", for: .normal)
        MicBtn.imageView?.image = UIImage(systemName: "mic.circle.fill")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
//            playButton.isEnabled = true
            StopButton.isEnabled = false
            StopButton.isHidden = true
            MicBtn.isEnabled = true
            
            ChatMessage.append([messagedata(text: "", time: timeupdate!, isFirstUser: true, sendimagebool: false, sentimage: images as? UIImage , sentlabel: "", url: "\(audio_url)",ReceiverImageBool: false,doctoraudio: true,patientaudio: false,DoctorRecordLabel: "", date: Date.dateFromCustomString(customString: "\(dateupdate)"))])
            tableView.reloadData()
            let section = ChatMessage.count-1
            let row = ChatMessage[section].count-1
            tableView.scrollToRow(at: IndexPath(row:ChatMessage[section].count-1, section: ChatMessage.count-1), at: .top, animated: true)
        } catch {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        print("finished playing \(flag)")
        MicBtn.isEnabled = true
        StopButton.isEnabled = false
        StopButton.isHidden = true

    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        date()
        time()
        
        print("\(#function)")
        let randomid = NSUUID().uuidString

        print("finished recording \(flag)")
        StopButton.isEnabled = false
//        playButton.isEnabled = true
        MicBtn.setTitle("", for: UIControl.State())
        MicBtn.imageView?.image = UIImage(systemName: "mic.circle.fill")
        
        
            self.recorder = nil
            let uploadref = Storage.storage().reference(withPath: "chat/euO4eHLyxXKDVmLCpNsO/recordings/\(randomid).m4a")
         print("uploadref:\(uploadref)")
             let uploadMetadata = StorageMetadata()
            uploadMetadata.contentType = "audio/m4a"

            uploadref.putFile(from: soundFileURL, metadata: uploadMetadata){(downloadMetaData,error) in
                 if error != nil{
                     print("error path meta uploaddata 1 : \(error?.localizedDescription)")
                 return
                 }
                
                 print("\(String(describing: downloadMetaData))")
                 uploadref.downloadURL(completion:  { [self] (url,error) in
                     if error != nil
                     {
                         print("doewloadurl error msg \(error?.localizedDescription)")
                         return
                     }
                     if url != nil {
                         let url = url!.absoluteString
                        print("url: \(url)")
                        audio_url = url
                        print("audio_url : \(audio_url)")

                         db.collection("patient_chat").document(documentID).collection("messages").addDocument(data: ["sender_id": DoctorId,"sender_name": DoctorName,"text": "audio","time_stamp": FieldValue.serverTimestamp(),"type": 3,"content_url": url])
                        


                     }
             })
             }
        tableView.reloadData()
       
    }
    
    
    
    
    
    
    func askForNotifications() {
        print("\(#function)")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ComChatViewController.background(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
    }
    
    @objc func background(_ notification: Notification) {
        print("\(#function)")
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    

    
    func OnTouchDoctor(cell: AudioFileDoctorTableViewCell,didTappedThe button: UIButton?,indexSec: Int,index: Int) {
    
    guard let indexPath = tableView.indexPath(for: cell) else  { return }
    cell.DoctorAudioSlider.value = 0.0
    indexpathrow = index
    let storageref = Storage.storage().reference(forURL: ChatMessage[indexSec][index].url!)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("doctor.m4a")
        storageref.getData(maxSize: 10640060 ) { [self] (data, error) in
                if let error = error {
                    print(error)
                } else {
                    print("zero")

                    if let d = data {
                        print("one")
                        do {
                            print("two")

                            try d.write(to: fileURL)
                            self.player = try AVAudioPlayer(contentsOf: fileURL)
                            
                                print("nil")
                                self.player!.play()
                                player.currentTime = 0
                                cell.recordBtn.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
                                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true,block: {(timer) in
                                        if indexPath.row == indexpathrow{
                                            cell.DoctorAudioSlider.value = Float(player.currentTime)
                                        }
                                    })
                            
                                cell.DoctorAudioSlider.isHidden = false
                                cell.recordLabel.isHidden = true
                            
                        } catch {
                            print(error)
                        }
                    }
                }
        
            
        }
    }
    

    func OnTouchPatient(indexSec: Int,index: Int) {
        
        print("index: \(index) \(ChatMessage[indexSec][index].url)")
        let storageref = Storage.storage().reference(forURL: ChatMessage[indexSec][index].url!)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("patient.m4a")
        storageref.getData(maxSize: 10640060) { [self] (data, error) in
                if let error = error {
                    print(error)
                } else {
                    if let d = data {
                        do {
                            try d.write(to: fileURL)
                            self.player = try AVAudioPlayer(contentsOf: fileURL)
                            self.player.play()
                            print("player : \(player.duration)")
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        
    }
    
    func TouchImageDoctor(cell: ComImageTableViewCell, didTappedThe button: UIButton?, index: Int,indexsec: Int) {
        print("index : \(index)")
        Image_url = ChatMessage[indexsec][index].url
        print("Image_url : \(Image_url)")
        performSegue(withIdentifier: "ImageZoom", sender: self)
    }
    
    func TouchImagePatient(cell: ComChatReceiveimageTableViewCell, didTappedThe button: UIButton?, index: Int,indexsec: Int) {
        print("index : \(index)")
        Image_url = ChatMessage[indexsec][index].url
        print("Image_url : \(Image_url)")
        performSegue(withIdentifier: "ImageZoom", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ImageZoom"{
            let VC:ImageZoomViewController = segue.destination as! ImageZoomViewController
            VC.Patient_Id = Patient_Id
            VC.documentID = documentID
            VC.Image_url = Image_url
            VC.DoctorId = DoctorId


        }    }
    
    


    }



class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        textColor = .white
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false // enables auto layout
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
    
}
