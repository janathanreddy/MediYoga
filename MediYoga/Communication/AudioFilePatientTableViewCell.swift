//
//  AudioFilePatientTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 19/10/20.
//

import UIKit

class AudioFilePatientTableViewCell: UITableViewCell {

    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recordlabel: UILabel!
    @IBOutlet weak var recordbtn: UIButton!
    @IBOutlet weak var recordtimer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
