//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Request"

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
    
    init(photo: Photo) {
        super.init()
        self.status = "pending"
        self.photo = photo
        self.requester = PFUser.currentUser()!
    }
    
    @NSManaged var photo : Photo
    @NSManaged var requester : PFUser
    @NSManaged var status : String
    
    func acceptRequest() {
        self.photo.accessList.append(self.requester)
        self.status = "accepted"
        self.photo.saveInBackgroundWithBlock(nil)
        self.saveInBackgroundWithBlock(nil)
    }
    
    func denyRequest() {
        self.status = "denied"
        self.saveInBackgroundWithBlock(nil)
    }
}