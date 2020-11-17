//
//  PriscriptionTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 24/09/20.
//

import UIKit
protocol TableViewNew {
    
    func Favourite(cell:PriscriptionTableViewCell, didTappedThe button:UIButton?)
    func Check(cell:PriscriptionTableViewCell, didTappedThe button:UIButton?)

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
        
        celldelegate?.Favourite(cell: self, didTappedThe: sender as?UIButton)

    }
    
    
    @IBAction func checkmarkaction(_ sender: Any) {
        
        celldelegate?.Check(cell: self, didTappedThe: sender as?UIButton)


    }
    
    
}
