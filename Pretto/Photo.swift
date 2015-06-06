//
//  Photo.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class Photo {
    private static let kClassName = "Photo"
    private static let kThumbnailKey = "thumbnail"
    private static let kFullsizeKey = "fullsize"
    private static let kUserKey = "user"
    private static let kEventsKey = "events"
    
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
    
    var events : [Event]? {
        set { storage.setValue(events, forKey: Photo.kEventsKey) }
        get { return storage[Photo.kEventsKey] as? [Event] ?? nil }
    }
}