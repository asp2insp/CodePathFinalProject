//
//  Album.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/8/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Album"
private let kPhotosKey = "photos"

class Album : BackendObject {
    override init() {
        super.init(className: kClassName)
    }
    
    var photos : [ThumbnailPhoto] {
        set { setValue(photos, forKey: kPhotosKey) }
        get { return self[kPhotosKey] as? [ThumbnailPhoto] ?? [] }
    }
    
    func addPhoto(photo: ThumbnailPhoto) {
        var p = self.photos
        p.append(photo)
        self.photos = p
        self.saveEventually(nil)
    }
}