//
//  InvitationCell.swift
//  Pretto
//
//  Created by Baris Taze on 6/21/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class InvitationCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet private weak var invitationDescriptionLabel: UILabel!
    @IBOutlet private weak var joinButton: UIButton!
    
    var invitation: Invitation? {
        didSet {
            if self.invitation != nil {
                let from = User(innerUser: self.invitation!.from)
                let userImageUrlText = from.profilePhotoUrl!
                let userImageUrl = NSURL(string: userImageUrlText)
                self.userImageView.setImageWithURL(userImageUrl)
                
                let persona = from.firstName ?? from.email!
                let cellDescription = "\(persona) has invited you to their event: \(self.invitation!.event.title)"
                self.invitationDescriptionLabel.text = cellDescription
                
                if invitation!.accepted {
                    self.joinButton.enabled = false
                    self.backgroundColor = UIColor.prettoWindowBackground()
                } else {
                    self.joinButton.enabled = true
                    self.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var prettoColorAsImage = self.imageWithColor(UIColor.prettoBlue())
        self.joinButton.setBackgroundImage(prettoColorAsImage, forState: .Normal)
        self.joinButton.setBackgroundImage(prettoColorAsImage, forState: .Highlighted)
        self.joinButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        self.joinButton.setTitleColor(UIColor.whiteColor(), forState:.Highlighted)
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

        // Configure the view for the selected state
    }

    @IBAction func onJoinButton(sender: AnyObject) {
        self.invitation!.accepted = true
        self.invitation!.saveInBackground()
        self.joinButton.enabled = false
        self.backgroundColor = UIColor.prettoWindowBackground()
        println("joined event...")
    }
}
