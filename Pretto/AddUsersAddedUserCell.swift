//
//  AddUsersAddedUserCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AddUsersAddedUserCell: UITableViewCell {

    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    
    var facebookId: String! {
        didSet{
            self.userProfileImage.clipsToBounds = true
            self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.width / 2
            self.userProfileImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.userProfileImage.layer.borderWidth = 1
            self.userProfileImage.contentMode = UIViewContentMode.ScaleAspectFill
            self.userProfileImage.setImageWithURL(NSURL(string: "https://graph.facebook.com/\(self.facebookId)/picture?type=large&return_ssl_resources=1")!)
        }
    }
    
    var userName: String! {
        didSet {
            self.userNameLabel.text = userName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
