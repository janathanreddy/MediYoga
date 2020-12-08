//
//  ComChatReceiveimageTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 16/10/20.
//

import UIKit
protocol PatientImage {
    func TouchImagePatient(cell: ComChatReceiveimageTableViewCell,didTappedThe button:UIButton?,index: Int,indexsec: Int)
}

class ComChatReceiveimageTableViewCell: UITableViewCell {

    @IBOutlet weak var ReceiverView: UIView!
    @IBOutlet weak var ReceiverImage: UIImageView!
    @IBOutlet weak var ReceiverTime: UILabel!
    @IBOutlet weak var ReceiverImageLabel: UILabel!
    @IBOutlet weak var ImageTouchBtn: UIButton!
    
    @IBOutlet weak var ReadCheck: UILabel!
    
    var index: IndexPath?
    var CellDelegate: PatientImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        ReceiverView.layer.borderWidth = 0.5

        ReceiverView.layer.borderColor = UIColor.systemGray.cgColor

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ImageTouchAction(_ sender: Any) {
        
        print("Button Pressed")
        CellDelegate?.TouchImagePatient(cell: self,didTappedThe: sender as?UIButton,index: index!.row, indexsec: index!.section)
        print("Cell Index : \(index?.row)")


    }
}
