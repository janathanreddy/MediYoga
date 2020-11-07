//
//  MonthlyTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 07/11/20.
//

import UIKit

class MonthlyTableViewCell: UITableViewCell {

    @IBOutlet weak var AppointmentTime: UILabel!
    @IBOutlet weak var PatientName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
