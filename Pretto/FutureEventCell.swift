//
//  FutureEventCell.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/24/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class FutureEventCell: UITableViewCell {

    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var albumLocation: UILabel!
    @IBOutlet var calendarSheet: UIView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    var event : Event? {
        didSet {
            self.updateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.None
        accessoryType = UITableViewCellAccessoryType.None
        monthLabel.textColor = UIColor.orangeColor()
        dayLabel.textColor = UIColor.orangeColor()
        albumTitle.preferredMaxLayoutWidth = albumTitle.frame.size.width
        albumLocation.preferredMaxLayoutWidth = albumLocation.frame.size.width
        calendarSheet.layer.cornerRadius = 3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateData() {
        if let event = self.event {
            albumTitle.text = event.title
            dateFormatter.dateFormat = "MMM"
            monthLabel.text = dateFormatter.stringFromDate(event.startDate)
            dateFormatter.dateFormat = "dd"
            dayLabel.text = dateFormatter.stringFromDate(event.startDate)
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: event.latitude, longitude: event.longitude), completionHandler: { (markers, error) -> Void in
                if markers.count > 0 {
                    let marker = markers[0] as! CLPlacemark
                    self.albumLocation.text = "\(marker.locality), \(marker.subLocality)"
                }
            })
        }
    }
}
