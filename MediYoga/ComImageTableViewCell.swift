//
//  ComImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 03/10/20.
//

import UIKit

class ComImageTableViewCell: UITableViewCell {

    @IBOutlet weak var sendimage: UIImageView!
    @IBOutlet weak var sendlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
