//
//  AbumGeneralViewCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreLocation

class AlbumGeneralViewCell: UITableViewCell {
    @IBOutlet var albumImages: [PFImageView]!

    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var albumLocation: UILabel!
    @IBOutlet var calendarSheet: UIView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet var cardView: UIView!
    
    var event : Event? {
        didSet {
            self.updateData()
        }
    }
    
    var photos : [Photo] = []
    
    private let sideMargin = CGFloat(16.0)
    private let imageVerticalSeparator = CGFloat(2.0)
    private let imageHorizontalSeparator = CGFloat(2.0)
    private var imageWidth: CGFloat!
    private var imageHeight: CGFloat!
    
    private let placeHolder: UIImage! = UIImage(named: "PalmBWBorder")
    
    private var monthFormatter = NSDateFormatter()
    private var dayFormatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderColor = UIColor.prettoLightGrey().CGColor
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 5
        monthFormatter.dateFormat = "MMM"
        dayFormatter.dateFormat = "d"
        selectionStyle = UITableViewCellSelectionStyle.None
        accessoryType = UITableViewCellAccessoryType.None
        monthLabel.textColor = UIColor.orangeColor()
        dayLabel.textColor = UIColor.orangeColor()
        albumTitle.preferredMaxLayoutWidth = albumTitle.frame.size.width
        albumLocation.preferredMaxLayoutWidth = albumLocation.frame.size.width
        
        calendarSheet.layer.cornerRadius = 3
        
        imageWidth = self.frame.width - (2 * sideMargin) - (3 * imageHorizontalSeparator)
        imageHeight = imageWidth
        
        for imageView in albumImages {
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
            imageView.image = placeHolder
        }

    }
    
    func updateData() {
        if let event = self.event {
            albumTitle.text = event.title
            monthLabel.text = monthFormatter.stringFromDate(event.startDate)
            dayLabel.text = dayFormatter.stringFromDate(event.startDate)
            // Now load the new images
            event.getAllPhotosInEvent(kOrderedByNewestFirst) {(photos) in
                self.moreLabel.text = photos.count > 7 ? "+ \(photos.count - 7)" : "..."
                let photoCount = min(photos.count, self.albumImages.count)
                for var i=0; i < photoCount; i++ {
                    let index = i
                    SwiftTryCatch.try({
                        photos[i].fetchIfNeededInBackgroundWithBlock({ (photo, err) -> Void in
                            self.albumImages[index].file = photos[index].thumbnailFile
                            self.albumImages[index].loadInBackground()
                        })
                        self.albumImages[i].file = photos[i].thumbnailFile
                        }, catch: { (error) in
                            // This is expected... file is still loading
                        }, finally: {
                            // close resources
                    })
                    self.albumImages[i].loadInBackground()
                }
                // Reset the image for any cells beyond the end of the current photos
                for var i=photoCount; i<self.albumImages.count; i++ {
                    self.albumImages[i].image = self.placeHolder
                }
            }
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: event.latitude, longitude: event.longitude), completionHandler: { (markers, error) -> Void in
                if markers.count > 0 {
                    let marker = markers[0] as! CLPlacemark
                    self.albumLocation.text = "\(marker.locality), \(marker.subLocality)"
                }
            })
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
