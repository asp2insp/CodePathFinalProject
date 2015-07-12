//
//  Event.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation
import CoreLocation

private let kClassName = "Event"

private let kEventTitleKey = "title"
internal let kEventStartDateKey = "startDate"
internal let kEventEndDateKey = "endDate"
internal let kOrderedByNewestFirst = "newestFirst"
private let kEventCoverPhotoKey = "coverPhoto"
private let kEventOwnerKey = "owner"
private let kEventPincodeKey = "pincode"
private let kEventLatitudeKey = "latitude"
private let kEventLongitudeKey = "longitude"
private let kEventLocationNameKey = "locationName"
private let kEventAdminsKey = "admins"
private let kEventGuestsKey = "guests"
private let kEventChannelKey = "channel"
internal let kEventIsPublicKey = "isPublic"


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
    
    @NSManaged var title : String
    @NSManaged var coverPhoto : PFFile?
    @NSManaged var startDate : NSDate
    @NSManaged var endDate : NSDate
    @NSManaged var owner : PFUser?
    @NSManaged var pincode : String?

    @NSManaged var geoPoint : PFGeoPoint
    @NSManaged var latitude : Double
    @NSManaged var longitude : Double
    @NSManaged var locationName : String?
    @NSManaged var admins : [PFUser]?
    @NSManaged var guests : [PFUser]?
    @NSManaged var channel : String?
    @NSManaged var visibility : String?
    
    // TODO - support more than one album per event, right now we're going
    // to have a 1:1 mapping
    @NSManaged var albums : [Album]
    
    var isLive : Bool {
        let now = NSDate()
        let afterStart = startDate.compare(now) == NSComparisonResult.OrderedAscending
        let beforeEnd = now.compare(endDate) == NSComparisonResult.OrderedAscending
        return afterStart && beforeEnd
    }
    
    override init() {
        super.init()
    }
    
    init?(dictionary: NSDictionary) {
        super.init()
        
        if let title = dictionary[kEventTitleKey] as? String {
            self.title = title
        } else {
            return nil
        }
        
        if let startDate = dictionary[kEventStartDateKey] as? NSDate {
            self.startDate = startDate
        } else {
            return nil
        }
        
        if let endDate = dictionary[kEventEndDateKey] as? NSDate {
            self.endDate = endDate
        } else {
            return nil
        }
        
        if let owner = dictionary[kEventOwnerKey] as? PFUser {
            self.owner = owner
        } else {
            return nil
        }
    
        self.coverPhoto = dictionary[kEventCoverPhotoKey] as? PFFile
        self.pincode = dictionary[kEventPincodeKey] as? String
        self.latitude = dictionary[kEventLatitudeKey] as! Double
        self.longitude = dictionary[kEventLongitudeKey] as! Double
        self.geoPoint = PFGeoPoint(latitude: self.latitude, longitude: self.longitude)
        self.admins = dictionary[kEventAdminsKey] as? [PFUser]
        self.guests = dictionary[kEventGuestsKey] as? [PFUser]
        self.channel = dictionary[kEventChannelKey] as? String
        self.visibility = dictionary[kEventIsPublicKey] as? String ?? "private"
    }

    func getAllPhotosInEvent(orderedBy: String?, block: ([Photo] -> Void)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var photos : Array<Photo> = []
            for album in self.albums {
//                album.fetchIfNeeded()
                album.fetch()
                for p in album.photos ?? [] {
                    SwiftTryCatch.try({ p.fetchIfNeeded() }, catch: nil, finally: nil)
                    photos.append(p)
                }
            }
            
            let order = orderedBy ?? ""
            switch order {
            case kOrderedByNewestFirst:
                photos.sort {(a: Photo, b: Photo) -> Bool in
                    let aCreated = a.createdAt ?? NSDate.distantPast() as! NSDate
                    let bCreated = b.createdAt ?? NSDate.distantPast() as! NSDate
                    return aCreated.compare(bCreated) == NSComparisonResult.OrderedDescending
                }
            default:
                break
            }
            dispatch_async(dispatch_get_main_queue()) {
                block(photos)
            }
        }
    }
    
    func addImageToEvent(image: Photo) {
        let album = self.albums[0]
        album.addPhoto(image)
    }
    
    func getInvitation() -> Invitation {
        let query = PFQuery(className:"Invitation", predicate: nil)
        query.whereKey("event", equalTo: self)
        query.whereKey("to", equalTo: PFUser.currentUser()!)
        let objects = query.findObjects()
        return objects![0] as! Invitation
    }
    
    func makeInvitationForUser(user: PFUser) -> Invitation {
        let invitation = Invitation()
        invitation.from = self.owner!
        invitation.to = user
        invitation.paused = false
        invitation.event = self
        invitation.accepted = false
        invitation.lastUpdated = NSDate()
        sendInvitationNotification(invitation)
        return invitation
    }
    
    func sendInvitationNotification(invite: Invitation) {
        println("Sending Push")
        if invite.from != invite.to {
            var pushQuery: PFQuery = PFInstallation.query()!
            pushQuery.whereKey("deviceType", equalTo: "ios")
            pushQuery.whereKey("user", equalTo: invite.to)
            let myString = User.currentUser!.name! + " invited you to an event"
            let data = ["alert" : myString, "badge" : "Increment"]
            let push = PFPush()
            push.setData(data)
            push.setQuery(pushQuery)
            push.sendPushInBackground()
        }
    }
    
    class func getNearbyEvents(location: CLLocationCoordinate2D, callback:([Event]->Void)) {
        let userGeoPoint = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        var query = PFQuery(className: kClassName)
        query.whereKey("geoPoint", nearGeoPoint: userGeoPoint, withinMiles:1.0)
        query.whereKey("visibility", equalTo: "public")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let events = objects as? [Event] {
                    callback(events)
                    return
                }
            }
            callback([])
        }
    }
    
//    class func createEventPushChannel() -> String {
//        dateFormatter.dateFormat = "MMyMhmMdyMyymhy" // just to mix things up a little ;)
//        let channelId = "\(PFUser.currentUser()!.objectId!)" + "\(dateFormatter.stringFromDate(NSDate()))"
//
//        let currentInstallation = PFInstallation.currentInstallation()
//        currentInstallation.addUniqueObject(channelId, forKey: "channels")
//        currentInstallation.saveInBackground()
//        
//        return channelId
//    }
}