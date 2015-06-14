//
//  Invitation.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Invitation"

class Invitation : PFObject, PFSubclassing {
    
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
    
    
    @NSManaged var event : Event
    @NSManaged var from : PFUser
    @NSManaged var to : PFUser
    @NSManaged var paused: Bool
    @NSManaged var accepted: Bool
    
    var shouldUploadPhotos : Bool {
        return accepted && !paused
    }
}