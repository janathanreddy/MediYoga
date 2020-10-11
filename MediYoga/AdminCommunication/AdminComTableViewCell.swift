//
//  AdminComTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 11/10/20.
//

import UIKit

class AdminComTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var ChatTime: UILabel!
    @IBOutlet weak var ReadCheck: UILabel!
    @IBOutlet weak var ChatLabel: UILabel!
    @IBOutlet weak var Chat_View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
