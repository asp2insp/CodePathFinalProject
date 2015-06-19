//
//  PushManager.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/19/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

// DO NOT PAY ATTENTION TO THIS. THIS CLASS IS ONLY FOR TESTING
import UIKit

typealias createChannelCompletion = (success: Bool, channelId: String?) -> ()

class PushManager: NSObject {

    class func createChannel(completion: createChannelCompletion) {
        dateFormatter.dateFormat = "MMyMhmMdyMyymhy" // just to mix things up a little ;)
        let channelId = "\(PFUser.currentUser()!.objectId!)" + "\(dateFormatter.stringFromDate(NSDate()))"
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(channelId, forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                completion(success: true, channelId: channelId)
            } else {
                completion(success: false, channelId: nil)
            }
        }
    }
    
    
    
}