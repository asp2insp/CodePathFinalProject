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
    
    private let placeHolder: UIImage! = UIImage(named: "placeholder")
    
    private var monthFormatter = NSDateFormatter()
    private var dayFormatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.monthFormatter.dateFormat = "MMM"
        self.dayFormatter.dateFormat = "d"
        self.backgroundColor = UIColor.prettoWhite()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.accessoryType = UITableViewCellAccessoryType.None
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
            event.getAllPhotosInEvent(nil) {(photos) in
                self.moreLabel.text = photos.count > 7 ? "+ \(photos.count - 7)" : ""
                let photoCount = min(photos.count, self.albumImages.count)
                for var i=0; i < photoCount; i++ {
                    SwiftTryCatch.try({
                        photos[i].fetchIfNeeded()
                        self.albumImages[i].file = photos[i].thumbnailFile
                        }, catch: { (error) in
                            println("\(error.description)")
                        }, finally: {
                            // close resources
                    })
                    self.albumImages[i].loadInBackground()
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
