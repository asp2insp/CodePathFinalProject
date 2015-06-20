//
//  Invitation.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation
import Photos

private let kClassName = "Invitation"

class Invitation : PFObject, PFSubclassing {
    
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
    
    @NSManaged var event : Event
    @NSManaged var from : PFUser
    @NSManaged var to : PFUser
    
    var paused: Bool {
        get { return self["paused"] as! Bool }
        set { self["paused"] = newValue }
    }
    var accepted: Bool {
        get { return self["accepted"] as! Bool }
        set { self["accepted"] = newValue }
    }
    @NSManaged var lastUpdated : NSDate?
    
    var shouldUploadPhotos : Bool {
        return accepted && !paused
    }
    
    func updateFromCameraRoll() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let startDate = self.lastUpdated ?? event.startDate
        lastUpdated = NSDate()
        
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, event.endDate)
        
        PHPhotoLibrary.requestAuthorization { (authStatus:PHAuthorizationStatus) -> Void in
            switch authStatus {
            case .NotDetermined:
                println("AuthStatus: NotDetermined")
            case .Restricted:
                println("AuthStatus: Restricted")
            case .Denied:
                println("AuthStatus: Denied")
            case .Authorized:
                println("AuthStatus: Authorized")
            default:
                println("AuthStatus: ERROR")
            }
        }
        
        let allResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.FastFormat
        requestOptions.version = PHImageRequestOptionsVersion.Current
        let requestManager = PHImageManager.defaultManager()
        println("Adding \(allResult.count) photos to \(event.title)")
        let targetSize = CGSizeMake(100, 100)
        for var i = 0; i < allResult.count; i++ {
            requestManager.requestImageForAsset(allResult[i] as! PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                let data = UIImageJPEGRepresentation(image, 0.5)
                let thumbFile = PFFile(data: data)
                thumbFile.saveInBackground()
                let image = Photo()
                image.thumbnailFile = thumbFile
                image.saveInBackgroundWithBlock({ (success, err) -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("PrettoNewPhotoForEvent", object: self.event)
                })
                self.event.addImageToEvent(image)
            })
        }
        saveInBackground()
    }
}