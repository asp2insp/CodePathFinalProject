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
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.joinButton.backgroundColor = UIColor.prettoBlue()
        self.joinButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        self.joinButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Selected)
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onJoinButton(sender: AnyObject) {
        println("joined event...")
    }
}
