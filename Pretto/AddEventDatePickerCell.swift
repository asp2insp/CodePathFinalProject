//
//  AddEventDatePickerCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

@objc protocol AddEventDatePickerCellDelegate {
    optional func addEventDatePickerCell(addEventDatePickerCell: AddEventDatePickerCell, isStartDatePicker: Bool, valueDidChange date: NSDate)
}

class AddEventDatePickerCell: UITableViewCell {

    @IBOutlet var datePicker: UIDatePicker!
    var isStartDate: Bool!
    var currentDate: NSDate? {
        didSet {
            if currentDate != nil {
                self.datePicker.date = currentDate!.laterDate(NSDate())
            } else {
                self.datePicker.date = NSDate()
            }
        }
    }
    var minimunDate: NSDate? {
        didSet{
            if isStartDate != nil {
                if minimunDate != nil && !isStartDate {
                    self.datePicker.minimumDate = NSDate().laterDate(minimunDate!)
                } else {
                    self.datePicker.minimumDate = NSDate()
                }
            } else {
                self.datePicker.minimumDate = NSDate()
            }
        }
    }
    
    weak var delegate: AddEventDatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.datePicker.addTarget(self, action: "datePickerValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func datePickerValueChanged() {
        delegate?.addEventDatePickerCell!(self, isStartDatePicker: isStartDate, valueDidChange: datePicker.date)
    }

}
