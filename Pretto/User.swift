//
//  User.swift
//  Pretto
//
//  Created by Baris Taze on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class User {
    
    var inner:PFUser!
    
    init(innerUser:PFUser!) {
        inner = innerUser
    }
    
    var email:String? {
        get {
            return self.inner.email
        }
        set {
            self.inner.email = newValue
        }
    }
    
    var name:String? {
        get {
            return self.inner.valueForKey("name") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "name")
        }
    }
    
    var facebookId:String? {
        get {
            return self.inner.valueForKey("facebookId") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "facebookId")
        }
    }
    
    var profilePhotoUrl:String? {
        get {
            if(self.facebookId != nil) {
                return "https://graph.facebook.com/\(self.facebookId)/picture?type=large&return_ssl_resources=1"
            } else {
                return nil
            }
        }
    }
    
    func printProperties() {
        println(self.facebookId)
        println(self.email)
        println(self.name)
        println(self.profilePhotoUrl)
    }
    
    func save() {
        self.inner.saveEventually()
    }
    
    class func getMe(onComplete:((User?)->Void)){
        var request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, res:AnyObject!, err:NSError!) -> Void in
            if err == nil && res != nil {
                var userData = res as! NSDictionary
                var facebookId = userData["id"] as! String
                var name = userData["name"] as! String
                var email = userData["email"] as! String?
                
                var currentUser = PFUser.currentUser()
                var user = User(innerUser: currentUser)
                user.facebookId = facebookId
                user.email = email
                user.name = name
                
                onComplete(user)
            }
            else {
                onComplete(nil)
            }
        }
    }
    
    
    
    class func getAllFacebookFriends(onComplete:(([Friend]?)->Void)){
        
    }
}