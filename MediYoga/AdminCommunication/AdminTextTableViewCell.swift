//
//  AdminTextTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit

class AdminTextTableViewCell: UITableViewCell {

    @IBOutlet weak var AdmintextView: UIView!
    
    @IBOutlet weak var AdmintailImageView: UIImageView!
    @IBOutlet weak var ReadCheck: UILabel!
    @IBOutlet weak var Admintime: UILabel!
    @IBOutlet weak var AdminText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        AdmintailImageView.image = image
           .resizableImage(withCapInsets:
                            UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                              resizingMode: .stretch)
           .withRenderingMode(.alwaysTemplate)
     }
    
}

