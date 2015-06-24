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
    
    var isUpdating : Bool = false
    
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
    
    // Get all photos from the camera roll past self.lastUpdated and add them to the event
    func updateFromCameraRoll() {
        if self.isUpdating {
            return
        }
        if !self.accepted || self.paused {
            lastUpdated = NSDate()
            return
        }
        self.isUpdating = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let startDate = self.lastUpdated ?? event.startDate
        lastUpdated = NSDate()
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, event.endDate)
        
        PHPhotoLibrary.requestAuthorization(nil)
        let allResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
        requestOptions.version = PHImageRequestOptionsVersion.Current
        requestOptions.synchronous = true
        
        let requestManager = PHImageManager.defaultManager()
        println("Adding \(allResult.count) photos to \(event.title)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            for var i = 0; i < allResult.count; i++ {
                let currentAsset = allResult[i] as! PHAsset
                var targetScaleRatio = CGFloat(Double(1248.0 / Double(currentAsset.pixelWidth)))
                println("Scale: \(targetScaleRatio)")
                var targetWidth = CGFloat(currentAsset.pixelWidth) * targetScaleRatio
                var targetHeight = CGFloat(currentAsset.pixelHeight) * targetScaleRatio
                let targetSize = CGSize(width: targetWidth, height: targetHeight)
                println("Width from \(currentAsset.pixelWidth) to \(targetWidth)")
                println("Height from \(currentAsset.pixelHeight) to \(targetHeight)")
                let targetRect = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
                requestManager.requestImageForAsset(currentAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFit, options: requestOptions, resultHandler: { (assetResult, info) -> Void in
                    UIGraphicsBeginImageContext(targetRect.size)
                    assetResult.drawInRect(targetRect)
                    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    let data = UIImageJPEGRepresentation(finalImage, 0.0)
                    println("Image Size = \(data.length)")
                    if data == nil {
                        return
                    }
                    let thumbFile = PFFile(data: data)
                    thumbFile.saveInBackground()
                    let image = Photo()
                    image.thumbnailFile = thumbFile
                    image.owner = PFUser.currentUser()!
                    image.localPath = currentAsset.localIdentifier
                    image.saveInBackgroundWithBlock({ (success, err) -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(kNewPhotoForEventNotification, object: self.event)
                        self.event.addImageToEvent(image)
                        self.event.saveInBackgroundWithBlock({ (success:Bool, erro:NSError?) -> Void in
                            self.saveInBackground()
                        })
                    })

                })
            }
            self.saveInBackground()
            self.isUpdating = false
        }
    }
    
    // Query for all live events in the background and call the given block with the result
    // Only returns live events where you have accepted the invitation
    class func getAllLiveEvents(block: ([Invitation] -> Void) ) {
        let query = PFQuery(className: "Invitation", predicate: nil)
        query.includeKey("event")
        
        let innerQuery = PFQuery(className: "Event", predicate: nil)
        innerQuery.whereKey(kEventStartDateKey, lessThanOrEqualTo: NSDate())
        innerQuery.whereKey(kEventEndDateKey, greaterThan: NSDate())
        
        query.whereKey("event", matchesQuery: innerQuery)
        query.whereKey("to", equalTo: PFUser.currentUser()!)
        query.whereKey("accepted", equalTo: true)
        query.includeKey("event")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var invites : [Invitation] = []
                for obj in items ?? [] {
                    if let invitation = obj as? Invitation {
                        invites.append(invitation)
                    }
                }
                block(invites)
            }
        }
    }
    
    // Query for all past events in the background and call the given block with the result
    class func getAllPastEvents(block: ([Invitation] -> Void) ) {
        let query = PFQuery(className: "Invitation", predicate: nil)
        query.includeKey("event")
        
        let innerQuery = PFQuery(className: "Event", predicate: nil)
        innerQuery.whereKey(kEventEndDateKey, lessThan: NSDate())
        
        query.whereKey("event", matchesQuery: innerQuery)
        query.whereKey("to", equalTo: PFUser.currentUser()!)
        query.includeKey("event")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var invites : [Invitation] = []
                for obj in items ?? [] {
                    if let invitation = obj as? Invitation {
                        invites.append(invitation)
                    }
                }
                block(invites)
            }
        }
    }
    
    // Query for all future events in the background and call the given block with the result
    class func getAllFutureEvents(block: ([Invitation] -> Void) ) {
        let query = PFQuery(className: "Invitation", predicate: nil)
        query.includeKey("event")
        
        let innerQuery = PFQuery(className: "Event", predicate: nil)
        innerQuery.whereKey(kEventStartDateKey, greaterThanOrEqualTo: NSDate())
        
        query.whereKey("event", matchesQuery: innerQuery)
        query.whereKey("to", equalTo: PFUser.currentUser()!)
        query.includeKey("event")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var invites : [Invitation] = []
                for obj in items ?? [] {
                    if let invitation = obj as? Invitation {
                        invites.append(invitation)
                    }
                }
                block(invites)
            }
        }
    }
    
    // Query for all future events (ongoing, and yet to come, that aren't accepted)
    // in the background and call the given block with the result
    class func getAllLiveAndFutureNonAcceptedEvents(block: ([Invitation] -> Void) ) {
        let query = PFQuery(className: "Invitation", predicate: nil)
        query.includeKey("event")
        
        let innerQuery = PFQuery(className: "Event", predicate: nil)
        innerQuery.whereKey(kEventEndDateKey, greaterThanOrEqualTo: NSDate())
        
        query.whereKey("event", matchesQuery: innerQuery)
        query.whereKey("to", equalTo: PFUser.currentUser()!)
        query.whereKey("accepted", equalTo: false)
        query.includeKey("event")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var invites : [Invitation] = []
                for obj in items ?? [] {
                    if let invitation = obj as? Invitation {
                        invites.append(invitation)
                    }
                }
                block(invites)
            }
        }
    }
}