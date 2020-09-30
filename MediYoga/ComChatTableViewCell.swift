//
//  ComChatTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit

class ComChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var CellMessageLabel: UILabel!
    var trailingConstraint:NSLayoutConstraint!
    var leadingConstraint:NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse() 
        CellMessageLabel.text = nil
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func updateMessageCell(by message: MessageData){
        messageBackgroundView.layer.cornerRadius = 16
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20)
        leadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20)
        CellMessageLabel.text = message.text
        if message.isFirstUser{
            messageBackgroundView.backgroundColor = UIColor(red: 53/255, green: 150/255, blue: 255/255, alpha: 1)
            trailingConstraint.isActive = true
            CellMessageLabel.textAlignment = .right
            
        }else {
            messageBackgroundView.backgroundColor = UIColor(red: 83/255, green: 160/255, blue: 93/255, alpha: 1)
            leadingConstraint.isActive = true
            CellMessageLabel.textAlignment = .left

        }
    }
}
