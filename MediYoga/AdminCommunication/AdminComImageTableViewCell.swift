//
//  AdminComImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit

class AdminComImageTableViewCell: UITableViewCell {

    @IBOutlet weak var AdminImage_View: UIView!
    @IBOutlet weak var ChatImage: UIImageView!
    @IBOutlet weak var AdminChatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AdminImage_View.layer.borderWidth = 0.5

        AdminImage_View.layer.borderColor = UIColor.systemGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
