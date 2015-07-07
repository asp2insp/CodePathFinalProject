//
//  AddEventTitleCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

@objc protocol AddEventTitleCellDelegate {
    optional func addEventTitleCell(addEventTitleCell: AddEventTitleCell, titleDidChange title: String)
}

class AddEventTitleCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var eventTitle: UITextField!
    @IBOutlet var titleCharCounter: UILabel!
    
    weak var delegate: AddEventTitleCellDelegate?
    
    var title: String! {
        didSet {
            eventTitle.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
        eventTitle.delegate = self
        eventTitle.autocapitalizationType = UITextAutocapitalizationType.Sentences
        eventTitle.borderStyle = UITextBorderStyle.None
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: kTextFieldDidChangeNotification, object: nil)
        
    }
    
    deinit {
        println("AddEventTitleCell : deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UITextFieldTextDidChangeNotification", object: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidChange(notification: NSNotification) {
        titleCharCounter.textColor = (titleCharCounter.text)!.toInt() != 0 ? UIColor.lightGrayColor() : UIColor.prettoRed()
        titleCharCounter.text = "\(50 - count(eventTitle.text))"
        if (titleCharCounter.text)!.toInt() == 0 {
            eventTitle.text = eventTitle.text.substringToIndex(eventTitle.text.endIndex.predecessor())
        }

        delegate?.addEventTitleCell!(self, titleDidChange: eventTitle.text)
    }

}

//MARK: UITextFieldDelegate

extension AddEventTitleCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.eventTitle.endEditing(true)
        return false
    }
    
}
