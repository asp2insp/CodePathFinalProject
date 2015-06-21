//
//  RequestCell.swift
//  Pretto
//
//  Created by Baris Taze on 6/21/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class RequestCell2: UITableViewCell {

    var request:Request? {
        didSet {
            if self.request != nil {
                let requester = User(innerUser: self.request!.requester)
                let userImageUrlText = requester.profilePhotoUrl!
                println("Requester Photo: \(userImageUrlText)")
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
        self.acceptButton.backgroundColor = UIColor.prettoBlue()
        self.acceptButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        self.acceptButton.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Selected)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onAcceptButton(sender: AnyObject) {
        println("accepted")
    }
}
