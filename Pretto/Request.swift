//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation
import Photos
private let kClassName = "Request"

class Request : PFObject, PFSubclassing {
    
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
    
    static func makeRequestForPhoto(photo: Photo) -> Request {
        var request = Request()
        request.status = "pending"
        request.photo = photo
        request.requester = PFUser.currentUser()!
        request.requestee = photo.owner
        return request
    }
    
    @NSManaged var photo : Photo
    @NSManaged var requester : PFUser
    @NSManaged var status : String
    @NSManaged var requestee : PFUser
    
    func acceptRequest() {
        self.photo.fetchIfNeededInBackgroundWithBlock { (photo, err) -> Void in
            if let photo = photo as? Photo {
                photo.addUniqueObject(self.requester, forKey: "accessList")
                if photo.fullsizeFile == nil {
                    PHPhotoLibrary.requestAuthorization(nil)
                    println("Searching for photo with id \(photo.localPath)")
                    let collections = PHAsset.fetchAssetsWithLocalIdentifiers([photo.localPath], options: nil)
                    if collections.count > 0 {
                        println("Found photo, fetching...")
                        let requestOptions = PHImageRequestOptions()
                        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
                        requestOptions.version = PHImageRequestOptionsVersion.Original
                        let requestManager = PHImageManager.defaultManager()
                        requestManager.requestImageForAsset(collections[0] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                            println("Got photo, starting upload...")
                            let data = UIImagePNGRepresentation(image!)
                            photo.fullsizeFile = PFFile(data: data)
                            photo.fullsizeFile?.saveInBackgroundWithBlock({ (success, err) -> Void in
                                println("Finished upload")
                                photo.saveInBackground()
                            })
                        })
                    }
                } else {
                    photo.saveInBackground()
                }
            }
        }

        self.status = "accepted"
        self.saveInBackground()
    }
    
    func denyRequest() {
        self.status = "denied"
        self.saveInBackground()
    }
    
    static func getAllPendingRequests(completion: ([Request] -> Void)) {
        let query = PFQuery(className: kClassName)
        query.whereKey("requestee", equalTo: PFUser.currentUser()!)
        query.whereKey("status", equalTo: "pending")
        query.findObjectsInBackgroundWithBlock { (results, err) -> Void in
            completion(results as! [Request])
        }
    }
}