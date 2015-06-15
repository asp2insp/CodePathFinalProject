//
//  AddEventPhotoCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

@objc protocol addEventPhotoCellDelegate {
    optional func addEventPhotoCell(addEventPhotoCell: AddEventPhotoCell, didTapOnEventPhoto photo: UIImageView)
}

class AddEventPhotoCell: UITableViewCell {

    @IBOutlet var eventPhoto: UIImageView!
    
    weak var delegate: addEventPhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
        
        eventPhoto.userInteractionEnabled = true
        eventPhoto.layer.borderWidth = 1
        eventPhoto.layer.borderColor = UIColor.lightGrayColor().CGColor
        eventPhoto.layer.cornerRadius = 25
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "didTapOnEventPhoto")
        eventPhoto.addGestureRecognizer(tapRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func didTapOnEventPhoto() {
        delegate?.addEventPhotoCell!(self, didTapOnEventPhoto: self.eventPhoto)
    }

}
