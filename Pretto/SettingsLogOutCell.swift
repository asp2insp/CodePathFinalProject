//
//  SettingsLogOutCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/11/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class SettingsLogOutCell: UITableViewCell {

    @IBOutlet weak var logOutButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.accessoryType = .None
        logOutButton.textColor = UIColor.prettoOrange()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
