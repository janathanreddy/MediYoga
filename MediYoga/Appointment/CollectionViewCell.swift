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
    }

}
