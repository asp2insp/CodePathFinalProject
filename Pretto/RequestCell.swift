//
//  RequestCell.swift
//  Pretto
//
//  Created by Baris Taze on 6/21/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    var request:Request? {
        didSet {
            if self.request != nil {
                let requester = User(innerUser: self.request!.requester)
                let userImageUrlText = requester.profilePhotoUrl!
                let userImageUrl = NSURL(string: userImageUrlText)
                self.userImageView.setImageWithURL(userImageUrl)
                
                let requesterId = requester.firstName ?? requester.email!
                let cellDescription = "\(requesterId) has requested a photo from you!"
                self.notificationDescriptionLabel.text = cellDescription
            }
        }
    }
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var notificationDescriptionLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var prettoColorAsImage = self.imageWithColor(UIColor.prettoBlue())
        self.acceptButton.setBackgroundImage(prettoColorAsImage, forState: .Normal)
        self.acceptButton.setBackgroundImage(prettoColorAsImage, forState: .Highlighted)
        self.acceptButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.acceptButton.setTitleColor(UIColor.whiteColor(), forState:.Highlighted)
    }

    func imageWithColor(color:UIColor) -> UIImage {
        var rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onAcceptButton(sender: AnyObject) {
        println("accepted photo request")
    }
}
