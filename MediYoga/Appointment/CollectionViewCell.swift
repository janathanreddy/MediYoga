//
//  CollectionViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 01/11/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionViewCell"

    @IBOutlet weak var title_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let redvalue = CGFloat(drand48())
        let greenvalue = CGFloat(drand48())
        let bluevalue = CGFloat(drand48())

        title_Label.textColor = UIColor(red: redvalue, green: greenvalue, blue: bluevalue, alpha: 1)


        
    }

}
