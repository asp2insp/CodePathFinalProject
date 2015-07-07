//
//  AddEventLocationCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AddEventLocationCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cellTitle.textColor = UIColor.prettoOrange()
        cellContent.textColor = UIColor.darkGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
