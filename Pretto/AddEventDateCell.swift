//
//  AddEventDateCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AddEventDateCell: UITableViewCell {

    @IBOutlet var startOrEndLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var isStartDate: Bool! {
        didSet {
            startOrEndLabel.text = isStartDate! ? "Starts on" : "Ends on"
        }
    }
    
    var date: NSDate! {
        didSet {
            dateFormatter.dateFormat = "MMM, d yyyy - hh:mm a"
            dateLabel.text = dateFormatter.stringFromDate(date)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.dateLabel.textColor = UIColor.prettoOrange()
        self.startOrEndLabel.textColor = UIColor.lightGrayColor()
        self.tintColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
