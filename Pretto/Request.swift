//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Request"
private let kPhotoKey = "photo"
private let kRequesterKey = "requester"
private let kRequestStatusKey = "status"

class Request : PFObject, PFSubclassing {
    
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
    
    init(photo: ThumbnailPhoto) {
        super.init(className: kClassName)
        self.status = "pending"
        self.photo = photo
        self.requester = PFUser.currentUser()
    }
    
    var photo : ThumbnailPhoto? {
        set(newValue) { setValue(newValue, forKey: kPhotoKey) }
        get { return self[kPhotoKey] as? ThumbnailPhoto ?? nil }
    }
    
    var requester : PFUser? {
        set(oldValueOrNil) {
            setValue(oldValueOrNil, forKey: kRequesterKey)
            if let oldValue = oldValueOrNil {
                self.ACL?.setWriteAccess(false, forUser: oldValue)
            }
            if let newValue = requester {
                self.ACL?.setWriteAccess(true, forUser: newValue)
            }
        }
        get { return self[kRequesterKey] as? PFUser ?? nil }
    }
    
    var status : String? {
        set(newValue) { setValue(newValue, forKey: kRequestStatusKey) }
        get { return self[kRequestStatusKey] as? String ?? nil }
    }
    
    func acceptRequest() {
        if let desiredPhoto = self.photo?.fullsizePhoto?.fetchIfNeeded() {
            if self.requester != nil {
                desiredPhoto.ACL?.setReadAccess(true, forUser: self.requester!)
                self.status = "accepted"
                desiredPhoto.saveInBackgroundWithBlock(nil)
                self.saveInBackgroundWithBlock(nil)
            }
        }
    }
    
    func denyRequest() {
        self.status = "denied"
        self.saveInBackgroundWithBlock(nil)
    }
}