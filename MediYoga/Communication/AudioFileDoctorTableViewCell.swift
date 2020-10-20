//
//  AudioFileDoctorTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 19/10/20.
//

import UIKit

class AudioFileDoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordtimer: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
    
}
