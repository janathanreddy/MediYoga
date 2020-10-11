//
//  PriscriptionTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit
protocol TableViewNew {
       func onClickCell(index:Int)
       func onClickCell_1(index:Int)

   }

class PriscriptionTableViewCell: UITableViewCell {
    var celldelegate: TableViewNew?
    var index: IndexPath?

    @IBOutlet weak var favbtn: UIButton!
    @IBOutlet weak var PriscriptionLabel: UILabel!
    @IBOutlet weak var checkbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favbtnaction(_ sender: Any) {
        
//        celldelegate?.onClickCell(index: index!.row)
        favbtn.isSelected = !favbtn.isSelected


    }
    
    
    @IBAction func checkmarkaction(_ sender: Any) {
        
//        celldelegate?.onClickCell_1(index: index!.row)
        checkbtn.isSelected = !checkbtn.isSelected

    }
    
    
}
