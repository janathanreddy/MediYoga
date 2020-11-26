//
//  ComChatReceiverTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 05/10/20.
//

import UIKit

class ComChatReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var ReceiverLabel: UILabel!
    @IBOutlet weak var ReceiverView: UIView!
    @IBOutlet weak var ReceiverTime: UILabel!
    @IBOutlet weak var ReadCheck: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
