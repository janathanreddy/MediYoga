//
//  AdminAudioTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit
//
//protocol AdminGroupplay {
//    func OnTouchAdmin(index: Int)
//}


class AdminAudioTableViewCell: UITableViewCell {

//    var index: IndexPath?
//    var celldelegate: AdminGroupplay?

    
    @IBOutlet weak var AdminView: UIView!
    
    @IBOutlet weak var AdminAudioBtn: UIButton!
    @IBOutlet weak var AdminLabel: UILabel!
    
    @IBOutlet weak var AdminMeter: UILabel!
    
    @IBOutlet weak var AdminTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func AdminPlayButton(_ sender: Any) {
//        celldelegate?.OnTouchAdmin(index: index!.row)

    }
    
    
}
