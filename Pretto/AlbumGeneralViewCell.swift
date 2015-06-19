//
//  AbumGeneralViewCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AlbumGeneralViewCell: UITableViewCell {



    @IBOutlet var albumImages: [UIImageView]!

    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var albumLocation: UILabel!
    @IBOutlet var calendarSheet: UIView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!

    
    private let sideMargin = CGFloat(16.0)
    private let imageVerticalSeparator = CGFloat(2.0)
    private let imageHorizontalSeparator = CGFloat(2.0)
    private var imageWidth: CGFloat!
    private var imageHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.prettoWhite()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
        albumTitle.preferredMaxLayoutWidth = albumTitle.frame.size.width
        albumLocation.preferredMaxLayoutWidth = albumLocation.frame.size.width
        
        calendarSheet.layer.cornerRadius = 3
//        calendarSheet.layer.borderColor = UIColor.lightGrayColor().CGColor
//        calendarSheet.layer.borderWidth = 1
        
        imageWidth = self.frame.width - (2 * sideMargin) - (3 * imageHorizontalSeparator)
        imageHeight = imageWidth
        
        for album in albumImages {
            album.clipsToBounds = true
            album.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
            album.image = UIImage(named: "friends_6")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumTitle.preferredMaxLayoutWidth = albumTitle.frame.size.width
        albumLocation.preferredMaxLayoutWidth = albumLocation.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
