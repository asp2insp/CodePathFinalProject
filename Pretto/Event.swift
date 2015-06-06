//
//  Event.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class Event {
    private static let kClassName = "Event"
    private static let kThumbnailKey = "thumbnail"
    private static let kFullsizeKey = "fullsize"
    private static let kUserKey = "user"
    
    private var storage : BackendObject = BackendObject(className: kClassName)
    
    var thumbnailFile : BackendFile? {
        set { storage.setValue(thumbnailFile, forKey: Photo.kThumbnailKey) }
        get { return storage[Photo.kThumbnailKey] as? BackendFile ?? nil }
    }
    
    var fullsizeFile : BackendFile? {
        set { storage.setValue(fullsizeFile, forKey: Photo.kFullsizeKey) }
        get { return storage[Photo.kFullsizeKey] as? BackendFile ?? nil }
    }
    
    var user : BackendUser? {
        set { storage.setValue(user, forKey: Photo.kUserKey) }
        get { return storage[Photo.kUserKey] as? BackendUser ?? nil }
    }
    
    var event : Event? {
        set { storage.setValue(event, forKey: Photo.kEventKey) }
        get { return storage[Photo.kEventKey] as? Event ?? nil }
    }
}