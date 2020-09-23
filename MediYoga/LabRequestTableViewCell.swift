//
//  LabRequestTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit

class LabRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var labIMAGE: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
