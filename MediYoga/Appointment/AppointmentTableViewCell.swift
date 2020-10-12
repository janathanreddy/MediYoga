//
//  ApplicationTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

protocol TableViewCellindex {
    func OnTouch(index: Int)
}


class AppointmentTableViewCell: UITableViewCell {
    
    var index: IndexPath?
    var celldelegate: TableViewCellindex?
    
    @IBOutlet weak var appointmentimage: UIImageView!
    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var AgeField: UILabel!
    @IBOutlet weak var statusField: UIImageView!
    @IBOutlet weak var ccdField: UILabel!
    @IBOutlet weak var TimeField: UILabel!
    @IBOutlet weak var notesbtn: UIButton!

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
        celldelegate?.OnTouch(index: index!.row)
    }
    
    
}
