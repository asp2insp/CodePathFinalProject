//
//  Photo.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kThumbnailKey = "thumbnail"
private let kFullsizeKey = "fullsize"
private let kUserKey = "user"
private let kEventsKey = "events"
private let kLocalPathKey = "localPath"

class Photo {
    private static let kClassName = "Photo"
    private var storage : BackendObject = BackendObject(className: kClassName)
    
    var thumbnailFile : BackendFile? {
        set { storage.setValue(thumbnailFile, forKey: kThumbnailKey) }
        get { return storage[kThumbnailKey] as? BackendFile ?? nil }
    }
    
    var fullsizeFile : BackendFile? {
        set { storage.setValue(fullsizeFile, forKey: kFullsizeKey) }
        get { return storage[kFullsizeKey] as? BackendFile ?? nil }
    }
    
    var user : BackendUser? {
        set { storage.setValue(user, forKey: kUserKey) }
        get { return storage[kUserKey] as? BackendUser ?? nil }
    }
    
    var events : [Event]? {
        set { storage.setValue(events, forKey: kEventsKey) }
        get { return storage[kEventsKey] as? [Event] ?? nil }
    }
    
    var acl : BackendACL? {
        set { storage.ACL = acl }
        get { return storage.ACL as? BackendACL ?? nil }
    }
    
    var localPath : String? {
        set { storage.setValue(localPath, forKey: kLocalPathKey) }
        get { return storage[kLocalPathKey] as? String ?? nil }
    }
}