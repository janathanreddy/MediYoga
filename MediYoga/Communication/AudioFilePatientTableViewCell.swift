//
//  AudioFilePatientTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 19/10/20.
//

import UIKit

protocol PatientPlay {
    func OnTouchPatient(index: Int)
}


class AudioFilePatientTableViewCell: UITableViewCell {
    var index: IndexPath?
    var celldelegate: PatientPlay?
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordlabel: UILabel!
    @IBOutlet weak var recordbtn: UIButton!
    @IBOutlet weak var recordtimer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func PlayAction(_ sender: Any) {
        
        celldelegate?.OnTouchPatient(index: index!.row)

    }
    
    
}
