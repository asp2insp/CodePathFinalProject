//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Request"
private let kPhotoKey = "photo"
private let kRequesterKey = "requester"

class Request : BackendObject {
    override init() {
        super.init(className: kClassName)
    }
    
    var photo : ThumbnailPhoto? {
        set { setValue(photo, forKey: kPhotoKey) }
        get { return self[kPhotoKey] as? ThumbnailPhoto ?? nil }
    }
    
    var requester : BackendUser? {
        set { setValue(requester, forKey: kRequesterKey) }
        get { return self[kRequesterKey] as? BackendUser ?? nil }
    }
}