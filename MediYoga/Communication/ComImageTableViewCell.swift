//
//  ComImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 03/10/20.
//

import UIKit

class ComImageTableViewCell: UITableViewCell {

    @IBOutlet weak var sendimageview: UIView!
    @IBOutlet weak var sendimage: UIImageView!
    @IBOutlet weak var sendlabel: UILabel!
    @IBOutlet weak var ReadCheck: UILabel!
    @IBOutlet weak var ImageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sendimageview.layer.borderWidth = 0.5

        sendimageview.layer.borderColor = UIColor.systemGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
