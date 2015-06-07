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

class ThumbnailPhoto : BackendObject {
    override init() {
        super.init(className: kClassName)
    }
    
    var file : BackendFile? {
        set { setValue(file, forKey: kFileKey) }
        get { return self[kFileKey] as? BackendFile ?? nil }
    }
    
    var fullsizePhoto : FullsizePhoto? {
        set { setValue(fullsizePhoto, forKey: kFullsizeKey) }
        get { return self[kFullsizeKey] as? FullsizePhoto ?? nil }
    }
    
    var events : [Event]? {
        set { setValue(events, forKey: kEventsKey) }
        get { return self[kEventsKey] as? [Event] ?? nil }
    }
}