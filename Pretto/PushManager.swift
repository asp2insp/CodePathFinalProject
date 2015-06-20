//
//  PushManager.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/19/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

// DO NOT PAY ATTENTION TO THIS. THIS CLASS IS ONLY FOR TESTING
import UIKit

typealias createChannelCompletion = (success: Bool, channelId: String?, error: NSError?) -> ()
typealias subscribeToChannelCompletion = (success: Bool, error: NSError?) -> ()

class PushManager: NSObject {

    class func createPushChannel(completion: createChannelCompletion) {
        
        // Generate ChannelId
        dateFormatter.dateFormat = "MMyMhmMdyMyymhy" // just to mix things up a little ;)
        let channelId = "\(PFUser.currentUser()!.objectId!)" + "\(dateFormatter.stringFromDate(NSDate()))"
        
        // Subscribe current Installation to Channel
        PushManager.subscribeToPushChannel(channelId, completion: { (success, error) -> () in
            if success {
                completion(success: true, channelId: channelId, error: nil)
            } else {
                completion(success: false, channelId: nil, error: error)
            }
        })
    }
    
    class func subscribeToPushChannel(channelId: String, completion: subscribeToChannelCompletion) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(channelId, forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                completion(success: success, error: error)
        }
    }
    
    
    
}