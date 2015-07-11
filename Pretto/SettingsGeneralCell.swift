//
//  SettingsGeneralCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/11/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class SettingsGeneralCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.accessoryType = .DisclosureIndicator
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
