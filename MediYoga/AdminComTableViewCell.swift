////
////  AdminComTableViewCell.swift
////  MediYoga
////
////  Created by Janarthan Subburaj on 30/09/20.
////
//
//import UIKit
//
//class AdminComTableViewCell: UITableViewCell {
//
//    var trailingConstraint:NSLayoutConstraint!
//    var leadingConstraint:NSLayoutConstraint!
//    
//    @IBOutlet weak var ReadCheckLabelAdmin: UILabel!
//    @IBOutlet weak var timeLabelAdmin: UILabel!
//    @IBOutlet weak var messageBackgroundViewAdmin: UIView!
//    @IBOutlet weak var CellMessageLabelAdmin: UILabel!
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        CellMessageLabelAdmin.text = nil
//        leadingConstraint.isActive = false
//        trailingConstraint.isActive = false
//        
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
//    func updateMessageCell(by message: MessageData){
//        messageBackgroundViewAdmin.layer.cornerRadius = 16
//        trailingConstraint = messageBackgroundViewAdmin.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20)
//        leadingConstraint = messageBackgroundViewAdmin.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20)
//        CellMessageLabelAdmin.text = message.text
//        if message.isFirstUser{
//            messageBackgroundViewAdmin.backgroundColor = UIColor(red: 53/255, green: 150/255, blue: 255/255, alpha: 1)
//            trailingConstraint.isActive = true
//            CellMessageLabelAdmin.textAlignment = .right
//            timeLabelAdmin.textAlignment = .right
//            ReadCheckLabelAdmin.textAlignment = .right
//            
//        }
//            else {
//                messageBackgroundViewAdmin.backgroundColor = UIColor(red: 83/255, green: 160/255, blue: 93/255, alpha: 1)
//            leadingConstraint.isActive = true
//            CellMessageLabelAdmin.textAlignment = .left
//            timeLabelAdmin.textAlignment = .left
//            ReadCheckLabelAdmin.textAlignment = .left
//
//        }
//    }
//}
