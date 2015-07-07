//
//  AddEventPhotoCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

@objc protocol AddEventPhotoCellDelegate {
    optional func addEventPhotoCell(addEventPhotoCell: AddEventPhotoCell, didTapOnEventPhoto photo: UIImageView)
}

class AddEventPhotoCell: UITableViewCell {

    @IBOutlet var eventPhoto: UIImageView!
    @IBOutlet var addPhotoLabel: UILabel!
    
    weak var delegate: AddEventPhotoCellDelegate?
    
    var eventImage: UIImage? {
        didSet {
            self.eventPhoto.image = eventImage
            self.eventPhoto.layer.borderWidth = 0
            self.addPhotoLabel.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None

        addPhotoLabel.textColor = UIColor.prettoOrange()
        
        eventPhoto.userInteractionEnabled = true
        eventPhoto.layer.borderWidth = 1
        eventPhoto.layer.borderColor = UIColor.lightGrayColor().CGColor
        eventPhoto.layer.cornerRadius = 35
        eventPhoto.clipsToBounds = true
        eventPhoto.contentMode = UIViewContentMode.ScaleAspectFill
        
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
