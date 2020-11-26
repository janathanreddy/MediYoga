//
//  ComImageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 03/10/20.
//

import UIKit

protocol DoctorImage {
    func TouchImageDoctor(cell: ComImageTableViewCell,didTappedThe button:UIButton?,index: Int)

}

class ComImageTableViewCell: UITableViewCell {
    var index: IndexPath?
    var CellDelegate: DoctorImage?

    @IBOutlet weak var ImageBtn: UIButton!
    @IBOutlet weak var sendimageview: UIView!
    @IBOutlet weak var sendimage: UIImageView!
    @IBOutlet weak var sendlabel: UILabel!
    @IBOutlet weak var ReadCheck: UILabel!
    @IBOutlet weak var ImageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        sendimageview.layer.borderWidth = 0.5
        sendimage.isUserInteractionEnabled = false
        ImageBtn.isUserInteractionEnabled = true
        sendimageview.layer.borderColor = UIColor.systemGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func ImageActBtn(_ sender: Any) {
        print("Button Pressed")
        CellDelegate?.TouchImageDoctor(cell: self,didTappedThe: sender as?UIButton,index: index!.row)
        print("Cell Index : \(index?.row)")


    }
    
}
