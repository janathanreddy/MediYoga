//
//  DoctorAudioTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit

//protocol AdminGroupDoctorplay {
//    func OnTouchDoctor(index: Int)
//}


class DoctorAudioTableViewCell: UITableViewCell {
//    var index: IndexPath?
//    var celldelegate: AdminGroupDoctorplay?

    @IBOutlet weak var DoctorAudioView: UIView!
    
    @IBOutlet weak var DotorPlatBtn: UIButton!
    @IBOutlet weak var DoctorTime: UILabel!
    @IBOutlet weak var DoctorTimer: UILabel!
    @IBOutlet weak var DoctorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func DoctorPlayAction(_ sender: Any) {
//        celldelegate?.OnTouchDoctor(index: index!.row)
    }
    
    
}
