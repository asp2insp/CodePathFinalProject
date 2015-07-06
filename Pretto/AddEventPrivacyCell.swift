//
//  AddEventPrivacyCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AddEventPrivacyCell: UITableViewCell {

    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        cellTitle.textColor = UIColor.lightGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
