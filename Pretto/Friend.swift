//
//  Friend.swift
//  Pretto
//
//  Created by Baris Taze on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Friend"
private let kFacebookId = "facebookId"

class Friend  : PFObject, PFSubclassing {
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
    
    @NSManaged var facebookId : String
    @NSManaged var friendName : String
    @NSManaged var friendFacebookId : String
    
    func printDebug() {
        println("\(self.facebookId) - \(self.friendFacebookId) - \(self.friendName)")
    }
    
    class func printDebugAll(friends:[Friend]) {
        for friend in friends {
            friend.printDebug()
        }
    }
    
    class func getAllFriendsFromFacebook(myFacebookId:String, onComplete:(([Friend]?)->Void)) {
        var request = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, res:AnyObject!, err:NSError!) -> Void in
            if err == nil && res != nil {
                var friends:[Friend] = []
                var friendsDataList = (res as! NSDictionary)["data"] as! NSArray
                for data in friendsDataList {
                    var friendData = data as! NSDictionary
                    var friend = Friend()
                    friend.facebookId = myFacebookId
                    friend.friendFacebookId = friendData["id"] as! String
                    friend.friendName = friendData["name"] as! String
                    friends.append(friend)
                }
                
                onComplete(friends)
            }
            else {
                onComplete(nil)
            }
        }
    }
    
    class func getAllFriendsFromDBase(facebookId: String, onComplete: ([Friend]? -> Void) ) {
        let query = PFQuery(className: kClassName, predicate: nil)
        query.whereKey(kFacebookId, equalTo: facebookId)
        query.findObjectsInBackgroundWithBlock { (items, error) -> Void in
            if error == nil {
                var friends : [Friend] = []
                for obj in query.findObjects() ?? [] {
                    if let friend = obj as? Friend {
                        friends.append(friend)
                    }
                }
                onComplete(friends)
            }
            else {
                onComplete(nil)
            }
        }
    }
    
    class func subtract(those:[Friend], from:[Friend]) -> [Friend] {
        
        var hash = [String: Friend]()
        for f in those {
            hash[f.friendFacebookId] = f
        }
        
        var result = [Friend]()
        for f in from {
            if hash[f.friendFacebookId] == nil {
                result.append(f)
            }
        }
        
        return result
    }
}
