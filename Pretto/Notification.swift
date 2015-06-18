//
//  Notification.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/17/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class Notification : PFObject, PFSubclassing {
        
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Notification"
    }
    
    
    @NSManaged var user : PFUser
    @NSManaged var title : String
    @NSManaged var message : String
    @NSManaged var hasBeenRead : Bool
}