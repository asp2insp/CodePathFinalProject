//
//  Album.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/8/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Album"

class Album : PFObject, PFSubclassing {
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
    
    @NSManaged var photos: [Photo]?
    @NSManaged var event: Event
    
    func addPhoto(photo: Photo) {
        var p = self.photos ?? []
        p.append(photo)
        self.photos = p
        self.saveEventually(nil)
    }
    
    func addPhotos(photos: [Photo]) {
        var p = self.photos ?? []
        for photo in photos {
            p.append(photo)
        }
        self.photos = p
        self.saveEventually(nil)
    }
}