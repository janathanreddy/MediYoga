//
//  DoctorImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit

class DoctorImageTableViewCell: UITableViewCell {

    @IBOutlet weak var DoctorView: UIView!
    @IBOutlet weak var DoctorLabel: UILabel!
    @IBOutlet weak var DoctorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DoctorView.layer.borderWidth = 0.5

        DoctorView.layer.borderColor = UIColor.systemGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
