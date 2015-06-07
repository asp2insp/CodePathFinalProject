//
//  FullsizePhoto.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "FullsizePhoto"
private let kThumbnailKey = "thumbnail"
private let kLocalPathKey = "localPath"
private let kFileKey = "file"
private let kOwnerKey = "owner"

class FullsizePhoto : BackendObject {

    override init() {
        super.init(className: kClassName)
        self.ACL = BackendACL(user: BackendUser.currentUser()!)
    }
    
    var thumbnailPhoto : ThumbnailPhoto? {
        set { setValue(thumbnailPhoto, forKey: kThumbnailKey) }
        get { return self[kThumbnailKey] as? ThumbnailPhoto ?? nil }
    }
    
    var file : BackendFile? {
        set { setValue(file, forKey: kFileKey) }
        get { return self[kFileKey] as? BackendFile ?? nil }
    }
    
    var localPath : String? {
        set { setValue(localPath, forKey: kLocalPathKey) }
        get { return self[kLocalPathKey] as? String ?? nil }
    }
    
    var owner : BackendUser? {
        set { setValue(owner, forKey: kOwnerKey) }
        get { return self[kOwnerKey] as? BackendUser ?? nil }
    }
}