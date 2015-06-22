//
//  Request.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

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
        // TODO: below line is crashing
        // self.photo.accessList.append(self.requester)
        self.status = "accepted"
        self.photo.saveInBackgroundWithBlock(nil)
        self.saveInBackgroundWithBlock(nil)
    }
    
    func denyRequest() {
        self.status = "denied"
        self.saveInBackgroundWithBlock(nil)
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