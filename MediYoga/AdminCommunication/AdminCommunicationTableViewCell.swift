//
//  AdminCommunicationTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class AdminCommunicationTableViewCell: UITableViewCell {

    @IBOutlet weak var Group_Name: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Last_Message: UILabel!
    @IBOutlet weak var imagechat: UIImageView!
    @IBOutlet weak var UnseenCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        UnseenCount.clipsToBounds = true
        UnseenCount.layer.cornerRadius = 10
        imagechat.clipsToBounds = true
        imagechat.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
