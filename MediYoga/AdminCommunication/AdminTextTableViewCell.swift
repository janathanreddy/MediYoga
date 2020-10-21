//
//  AdminTextTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit

class AdminTextTableViewCell: UITableViewCell {

    @IBOutlet weak var AdmintextView: UIView!
    
    @IBOutlet weak var ReadCheck: UILabel!
    @IBOutlet weak var Admintime: UILabel!
    @IBOutlet weak var AdminText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
