//
//  AudioFileDoctorTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 19/10/20.
//

import UIKit

protocol Doctorplay {
    func OnTouchDoctor(cell: AudioFileDoctorTableViewCell,didTappedThe button:UIButton?,indexSec: Int,index: Int)

}


class AudioFileDoctorTableViewCell: UITableViewCell {
    
    var index: IndexPath?
    var celldelegate: Doctorplay?
    
    @IBOutlet weak var DoctorAudioSlider: UISlider!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordtimer: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        DoctorAudioSlider.minimumValue = 0
        DoctorAudioSlider.isContinuous = true


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func DoctorActionPlay(_ sender: Any) {

        celldelegate?.OnTouchDoctor(cell: self,didTappedThe: sender as?UIButton, indexSec: index!.section,index: index!.row)

        
    }
    
    
    
}
