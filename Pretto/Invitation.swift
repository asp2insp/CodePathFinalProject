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
    @NSManaged var paused: Bool
    @NSManaged var accepted: Bool
    @NSManaged var lastUpdated : NSDate?
    
    var shouldUploadPhotos : Bool {
        return accepted && !paused
    }
    
    func updateFromCameraRoll() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", event.startDateTime, event.endDateTime)
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
        for var i = 0; i < allResult.count; i++ {
            requestManager.requestImageDataForAsset(allResult[i] as! PHAsset, options: requestOptions, resultHandler: { (data, stringHuh, orientation, info) -> Void in
//                let photo = PFFile(data: data)
//                photo.saveInBackground()
//                let image = FullsizePhoto()
//                image.file = photo
//                image.saveInBackground()
                // TODO: Resize image and create thumbnail. Create fullsize photo without associated file
            })
        }
    }
}