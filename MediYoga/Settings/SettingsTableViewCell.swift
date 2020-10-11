//
//  SettingsTableViewCell.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func touchandfaceidswitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            print("faceid on")
        }
        else{
            print("faceid off")
        }
    }
    
}
