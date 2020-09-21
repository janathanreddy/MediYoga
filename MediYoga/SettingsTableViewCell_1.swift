//
//  SettingsTableViewCell_1.swift
//  MediYoga
//
//  Created by Janarthan Subburaj on 21/09/20.
//

import UIKit

class SettingsTableViewCell_1: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        print("hi")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    @IBAction func NotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("NotificationSwitch on")
        }
        else{
            print("NotificationSwitch off")
        }
    }
    
    
}
