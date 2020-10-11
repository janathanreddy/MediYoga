//
//  ComChatTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 29/09/20.
//

import UIKit

class ComChatTableViewCell: UITableViewCell {

    @IBOutlet weak var ReadCheckLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var CellMessageLabel: UILabel!
    var trailingConstraint:NSLayoutConstraint!
    var leadingConstraint:NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
