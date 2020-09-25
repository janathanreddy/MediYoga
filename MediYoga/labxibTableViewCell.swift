//
//  labxibTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 25/09/20.
//

import UIKit

class labxibTableViewCell: UITableViewCell {

    var indexPath: IndexPath!

    @IBOutlet weak var dropdownlabel: UILabel!
    @IBOutlet weak var btncheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func dropdownaction(_ sender: Any) {
    }
    
    class func cellHeight() -> CGFloat {
        return 42
    }
    
    class func reuseIdentifier() -> String {
        return "labxibTableViewCell"
    }
    class func nibName() -> String {
        return "labxibTableViewCell"
    }


}
