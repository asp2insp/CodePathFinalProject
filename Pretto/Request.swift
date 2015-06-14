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
        super.init()
        self.status = "pending"
        self.photo = photo
        self.requester = PFUser.currentUser()!
    }
    
    @NSManaged var photo : ThumbnailPhoto
    @NSManaged var requester : PFUser
    @NSManaged var status : String
    
    func acceptRequest() {
        if let desiredPhoto = self.photo.fullsizePhoto.fetchIfNeeded() {
            desiredPhoto.ACL?.setReadAccess(true, forUser: self.requester)
            self.status = "accepted"
            desiredPhoto.saveInBackgroundWithBlock(nil)
            self.saveInBackgroundWithBlock(nil)
        }
    }
    
    func denyRequest() {
        self.status = "denied"
        self.saveInBackgroundWithBlock(nil)
    }
}