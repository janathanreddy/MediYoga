//
//  CommunicationTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class CommunicationTableViewCell: UITableViewCell {

    @IBOutlet weak var ComDate: UILabel!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var CountUnseen: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var chatimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CountUnseen.clipsToBounds = true
        CountUnseen.layer.cornerRadius = 10
        chatimage.clipsToBounds = true
        chatimage.layer.cornerRadius = 20

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
