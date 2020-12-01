//
//  DoctorImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/10/20.
//

import UIKit


protocol AminDoctorImage {
    func AdminDoctorImage(cell: DoctorImageTableViewCell,didTappedThe button:UIButton?,index: Int,indexsec: Int)
}


class DoctorImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AdminDoctorTouch: UIButton!
    @IBOutlet weak var DoctorView: UIView!
    @IBOutlet weak var DoctorLabel: UILabel!
    @IBOutlet weak var DoctorImageView: UIImageView!
    var index: IndexPath?
    var CellDelegate: AminDoctorImage?

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        DoctorView.layer.borderWidth = 0.5

        DoctorView.layer.borderColor = UIColor.systemGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func AdminDoctorAct(_ sender: Any) {
        
        print("Button Pressed")
        CellDelegate?.AdminDoctorImage(cell: self,didTappedThe: sender as?UIButton,index: index!.row,indexsec: index!.section)
        print("Cell Index : \(index?.row)")


        
    }
    
    
}
