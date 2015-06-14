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

class ThumbnailPhoto : PFObject {
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
    
    override init() {
        super.init(className: kClassName)
    }
    
    var file : PFFile? {
        set(newValue) { setValue(newValue, forKey: kFileKey) }
        get { return self[kFileKey] as? PFFile ?? nil }
    }
    
    var fullsizePhoto : FullsizePhoto? {
        set(newValue) { setValue(newValue, forKey: kFullsizeKey) }
        get { return self[kFullsizeKey] as? FullsizePhoto ?? nil }
    }
    
    var events : [Event] {
        set(newValue) { setValue(newValue, forKey: kEventsKey) }
        get { return self[kEventsKey] as? [Event] ?? [] }
    }
}