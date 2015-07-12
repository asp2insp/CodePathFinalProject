//
//  AddEventPrivacyCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

protocol AddEventPrivacyCellDelegate {
    func didSetPrivacy(privacy: String)
}

class AddEventPrivacyCell: UITableViewCell {

    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var cellTitle: UILabel!
    
    var delegate : AddEventPrivacyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        cellTitle.textColor = UIColor.prettoOrange()
        isPublicSwitch.addTarget(self, action: "didSwitch", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func didSwitch() {
        delegate?.didSetPrivacy(isPublicSwitch.on ? "public" : "private")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
