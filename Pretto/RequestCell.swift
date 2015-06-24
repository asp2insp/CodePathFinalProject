//
//  RequestCell.swift
//  Pretto
//
//  Created by Baris Taze on 6/21/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

@objc protocol RequestActionDelegate {
    optional func onAcceptRequests(requests:[Request], sender: RequestCell)
    optional func onDeclineRequests(requests:[Request], sender: RequestCell)
}

class RequestCell: UITableViewCell {

    var delegate:RequestActionDelegate?
    
    var requests:[Request]? {
        didSet {
            if self.requests != nil && self.requests!.count > 0 {
                let requester = User(innerUser: self.requests![0].requester)
                let userImageUrlText = requester.profilePhotoUrl!
                let userImageUrl = NSURL(string: userImageUrlText)
                self.userImageView.setImageWithURL(userImageUrl)
                self.userImageView.layer.cornerRadius = 25
                
                
                let requesterId = requester.firstName ?? requester.email!
                let cellDescription = "\(requesterId) has requested \(self.requests!.count) photos from you!"
                self.notificationDescriptionLabel.text = cellDescription
                
//                if requests?.status != "pending" {
//                    self.acceptButton.enabled = false
//                    self.backgroundColor = UIColor.prettoWindowBackground()
//                } else {
//                    self.acceptButton.enabled = true
//                    self.backgroundColor = UIColor.whiteColor()
//                }
            }
        }
    }
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var notificationDescriptionLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
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
        for request in self.requests ?? [] {
            request.acceptRequest()
        }
        self.acceptButton.enabled = false
        self.backgroundColor = UIColor.prettoWindowBackground()
        println("accepted photo request")
        
        if self.delegate != nil {
            self.delegate!.onAcceptRequests?(self.requests!, sender: self)
        }
    }
}
