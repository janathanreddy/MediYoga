//
//  ComChatReceiveimageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 16/10/20.
//

import UIKit

class ComChatReceiveimageTableViewCell: UITableViewCell {

    @IBOutlet weak var ReceiverView: UIView!
    @IBOutlet weak var ReceiverImage: UIImageView!
    @IBOutlet weak var ReceiverTime: UILabel!
    @IBOutlet weak var ReceiverImageLabel: UILabel!
    
    @IBOutlet weak var ReadCheck: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ReceiverView.layer.borderWidth = 0.5

        ReceiverView.layer.borderColor = UIColor.systemGray.cgColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
