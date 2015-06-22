//
//  NoAlbumsCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/20/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class NoAlbumsCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var lowerCardView: UIView!
    @IBOutlet var myButton: UIButton!
    @IBAction func onButton(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kDidPressCreateEventNotification, object: nil))
    }
    @IBOutlet var arrow: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cornerRadius = CGFloat(5.0)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        
        var bounds = CGRect(x: cardView.bounds.origin.x - 2, y: cardView.bounds.origin.y - 2, width: cardView.bounds.width + 2, height: cardView.bounds.height + 2)
        
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = cornerRadius
        cardView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cardView.layer.borderWidth = 0
        cardView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        cardView.layer.shadowOffset = CGSize(width: 4, height: 4)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowPath = shadowPath.CGPath
        cardView.backgroundColor = UIColor.whiteColor()
        
        myButton.backgroundColor = UIColor.prettoBlue()
        myButton.titleLabel?.textColor = UIColor.whiteColor()
        myButton.tintColor = UIColor.whiteColor()
        myButton.layer.cornerRadius = 5
        
        lowerCardView.layer.cornerRadius = cornerRadius
        lowerCardView.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
