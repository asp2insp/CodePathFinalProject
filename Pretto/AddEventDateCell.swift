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
            startOrEndLabel.text = isStartDate! ? "Starts" : "Ends"
        }
    }
    
    var date: NSDate! {
        didSet {
            dateFormatter.dateFormat = "MMM, d - hh:mm a"
            if isStartDate! {
                var interval = abs(NSDate().timeIntervalSinceDate(date))
                if interval < (60 * 1) {
                    println("Time Interval Since Now = \(interval)")
                    dateLabel.text = "Now!"
                } else {
                    dateLabel.text = dateFormatter.stringFromDate(date)
                }
            } else {
                dateLabel.text = dateFormatter.stringFromDate(date)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.dateLabel.textColor = UIColor.lightGrayColor()
        self.startOrEndLabel.textColor = UIColor.prettoOrange()
        self.tintColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
