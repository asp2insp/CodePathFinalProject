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

class Event : BackendObject {
    static let sDateFormatter = NSDateFormatter()

    override init() {
        super.init(className: kClassName)
        
        // TODO - support more than one album
        let album = Album()
        album.saveEventually(nil)
        self.albums = [album]
        
        // TODO - set up other things here
    }
    
    var name : String? {
        set { setValue(name, forKey: kNameKey) }
        get { return self[kNameKey] as? String ?? nil }
    }
    
    var owner : BackendUser? {
        set { setValue(owner, forKey: kOwnerKey) }
        get { return self[kOwnerKey] as? BackendUser ?? nil }
    }
    
    var pincode : String? {
        set { setValue(pincode, forKey: kPinKey) }
        get { return self[kPinKey] as? String ?? nil }
    }
    
    var startDateTime : NSDate! {
        set {
            let encodedDate = Event.sDateFormatter.stringFromDate(startDateTime)
            setValue(encodedDate, forKey: kStartDateTimeKey)
        }
        get {
            if let encodedDate = self[kStartDateTimeKey] as? String {
                return Event.sDateFormatter.dateFromString(encodedDate)
            } else {
                return nil
            }
        }
    }
    
    var endDateTime : NSDate! {
        set {
            let encodedDate = Event.sDateFormatter.stringFromDate(endDateTime)
            setValue(encodedDate, forKey: kEndDateTimeKey)
        }
        get {
            if let encodedDate = self[kEndDateTimeKey] as? String {
                return Event.sDateFormatter.dateFromString(encodedDate)
            } else {
                return nil
            }
        }
    }
    
    var latitude : Double? {
        set { setValue(latitude, forKey: kLatitudeKey) }
        get { return self[kLatitudeKey] as? Double ?? nil }
    }
    
    var longitude : Double? {
        set { setValue(longitude, forKey: kLongitudeKey) }
        get { return self[kLongitudeKey] as? Double ?? nil }
    }
    
    var locationName : String? {
        set { setValue(locationName, forKey: kLocationNameKey) }
        get { return self[kLocationNameKey] as? String ?? nil }
    }
    
    var admins : [BackendUser] {
        set { setValue(locationName, forKey: kAdminsKey) }
        get { return self[kAdminsKey] as? [BackendUser] ?? [] }
    }
    
    var guests : [BackendUser] {
        set { setValue(guests, forKey: kGuestsKey) }
        get { return self[kGuestsKey] as? [BackendUser] ?? [] }
    }
    
    // TODO - support more than one album per event, right now we're going
    // to have a 1:1 mapping
    var albums : [Album] {
        set { setValue(guests, forKey: kAlbumsKey) }
        get { return self[kAlbumsKey] as? [Album] ?? [] }
    }
    
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
}