//
//  labxibTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 25/09/20.
//

import UIKit

protocol LabRequest_Xrays {
    
    func X_rays(cell:labxibTableViewCell, didTappedThe button:UIButton?)
   }

class labxibTableViewCell: UITableViewCell {

    var CellDelegate:LabRequest_Xrays!
    var indexPath: IndexPath!

    @IBOutlet weak var dropdownlabel: UILabel!
    @IBOutlet weak var btncheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func dropdownaction(_ sender: Any) {
        btncheck.isSelected = !btncheck.isSelected
        CellDelegate?.X_rays(cell: self, didTappedThe: sender as?UIButton)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
