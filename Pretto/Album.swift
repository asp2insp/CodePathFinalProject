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

class Album : PFObject {
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
    
    var photos : [ThumbnailPhoto] {
        set(newValue) { setValue(newValue, forKey: kPhotosKey) }
        get { return self[kPhotosKey] as? [ThumbnailPhoto] ?? [] }
    }
    
    func addPhoto(photo: ThumbnailPhoto) {
        var p = self.photos
        p.append(photo)
        self.photos = p
        self.saveEventually(nil)
    }
    
    func addPhotos(photos: [ThumbnailPhoto]) {
        var p = self.photos
        for photo in photos {
            p.append(photo)
        }
        self.photos = p
        self.saveEventually(nil)
    }
}