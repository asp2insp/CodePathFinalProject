//
//  Event.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Event"
private let kNameKey = "name"
private let kOwnerKey = "owner"
private let kPinKey = "pin"
private let kStartDateTimeKey = "startDateAndTime"
private let kEndDateTimeKey = "endDateAndTime"
private let kLatitudeKey = "latitude"
private let kLongitudeKey = "longitude"
private let kLocationNameKey = "locationName"
private let kAdminsKey = "admins"
private let kGuestsKey = "guests"
private let kAlbumsKey = "albums"

class Event : PFObject, PFSubclassing {
    static let sDateFormatter = NSDateFormatter()
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kClassName
    }
    
    @NSManaged var name : String
    @NSManaged var owner : PFUser
    @NSManaged var pincode : String
    @NSManaged var startDateTime : NSDate
    @NSManaged var endDateTime : NSDate
    @NSManaged var latitude : Double
    @NSManaged var longitude : Double
    @NSManaged var locationName : String
    @NSManaged var admins : [PFUser]
    @NSManaged var guests : [PFUser]
    
    // TODO - support more than one album per event, right now we're going
    // to have a 1:1 mapping
    @NSManaged var albums : [Album]
    
    var isLive : Bool {
        let now = NSDate()
        let afterStart = startDateTime.compare(now) == NSComparisonResult.OrderedAscending
        let beforeEnd = now.compare(endDateTime) == NSComparisonResult.OrderedAscending
        return afterStart && beforeEnd
    }

    
    func getAllPhotosInEvent(orderedBy: String?) -> [ThumbnailPhoto] {
        var photos : [ThumbnailPhoto] = []
        for album in self.albums {
            album.fetchIfNeeded()
            for p in album.photos {
                photos.append(p)
            }
        }
        
        let order = orderedBy ?? ""
        switch order {
        case "Date Descending":
            return photos // TODO - order by date
        default:
            return photos
        }
    }
    
    class func nowAsString() -> String {
        return Event.sDateFormatter.stringFromDate(NSDate())
    }
    
    // Query for all live events in the background and call the given block with the result
    class func getAllLiveEvents(block: ([Event] -> Void) ) {
        let query = PFQuery(className: kClassName, predicate: nil)
        query.whereKey(kStartDateTimeKey, lessThanOrEqualTo: nowAsString())
        query.whereKey(kEndDateTimeKey, greaterThan: nowAsString())
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var events : [Event] = []
                for obj in query.findObjects() ?? [] {
                    if let event = obj as? Event {
                        events.append(event)
                    }
                }
                block(events)
            }
        }
    }
    
    // Query for all past events in the background and call the given block with the result
    class func getAllPastEvents(block: ([Event] -> Void) ) {
        let query = PFQuery(className: kClassName, predicate: nil)
        query.whereKey(kEndDateTimeKey, lessThan: nowAsString())
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var events : [Event] = []
                for obj in query.findObjects() ?? [] {
                    if let event = obj as? Event {
                        events.append(event)
                    }
                }
                block(events)
            }
        }
    }
    
    // Query for all future events in the background and call the given block with the result
    class func getAllFutureEvents(block: ([Event] -> Void) ) {
        let query = PFQuery(className: kClassName, predicate: nil)
        query.whereKey(kStartDateTimeKey, greaterThanOrEqualTo: nowAsString())
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var events : [Event] = []
                for obj in query.findObjects() ?? [] {
                    if let event = obj as? Event {
                        events.append(event)
                    }
                }
                block(events)
            }
        }
    }
}