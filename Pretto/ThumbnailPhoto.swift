//
//  Photo.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kFileKey = "file"
private let kFullsizeKey = "fullsize"
private let kEventsKey = "events"
private let kClassName = "Photo"

class ThumbnailPhoto : PFObject, PFSubclassing {
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
    
    @NSManaged var file : PFFile
    @NSManaged var fullsizePhoto : FullsizePhoto
    @NSManaged var events : [Event]
}