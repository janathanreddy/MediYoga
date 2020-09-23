//
//  ApplicationTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

protocol TableViewCellDelegate: class {
  func didSelect(_ cell: UITableViewCell ,_ button: UIButton)
}

class ApplicationTableViewCell: UITableViewCell {
//    var index: IndexPath?
//    weak var delegate: TableViewCellDelegate?
    @IBOutlet weak var appointmentimage: UIImageView!
    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var AgeField: UILabel!
    @IBOutlet weak var statusField: UIImageView!
    @IBOutlet weak var ccdField: UILabel!
    @IBOutlet weak var TimeField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        appointmentimage.clipsToBounds = true
        appointmentimage.layer.cornerRadius = 30

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func NotesAction(_ sender: Any) {
//        delegate?.didSelect(self, sender as! UIButton)
    }
    
    
}
