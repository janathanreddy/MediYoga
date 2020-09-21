//
//  ApplicationTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class ApplicationTableViewCell: UITableViewCell {

    @IBOutlet weak var appointmentimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        appointmentimage.clipsToBounds = true
        appointmentimage.layer.cornerRadius = 30

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
