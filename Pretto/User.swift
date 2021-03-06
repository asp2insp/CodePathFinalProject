//
//  User.swift
//  Pretto
//
//  Created by Baris Taze on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class User {
    
    static var currentUser : User?
    
    var inner:PFUser!
    
    init(innerUser:PFUser!) {
        inner = innerUser
//        inner.fetchIfNeeded()
        inner.fetchIfNeededInBackground()
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
    
    var firstName:String? {
        get {
            return self.inner.valueForKey("first_name") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "first_name")
        }
    }
    
    var middleName:String? {
        get {
            return self.inner.valueForKey("middle_name") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "middle_name")
        }
    }

    var lastName:String? {
        get {
            return self.inner.valueForKey("last_name") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "last_name")
        }
    }
    
    var gender:String? {
        get {
            return self.inner.valueForKey("gender") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "gender")
        }
    }
    
    var locale:String? {
        get {
            return self.inner.valueForKey("locale") as! String?
        }
        set {
            self.inner.setValue(newValue, forKey: "locale")
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
                return "https://graph.facebook.com/\(self.facebookId!)/picture?type=large&return_ssl_resources=1"
            } else {
                return nil
            }
        }
    }
    
    var numberOfConnections: Int? {
        get {
            return self.inner.valueForKey("numberOfConnections") as! Int?
        }
        set {
            self.inner.setValue(newValue, forKey: "numberOfConnections")
        }
    }
    
    
    func printProperties() {
        println("facebookId: \(self.facebookId!)")
        println("Email: \(self.email!)")
        println("Full Name: \(self.name!)")
        println("First Name: \(self.firstName!)")
        println("Middle Name: \(self.middleName!)")
        println("Last Name: \(self.lastName!)")
        println("Gender: \(self.gender!)")
        println("locale: \(self.locale!)")
        println("Profile Image URL: \(self.profilePhotoUrl!)")
        println("Number of Connections: \(self.numberOfConnections!)")

    }
    
    func save() {
        self.inner.saveEventually()
    }
    
    class func checkCurrentUser(onValidUser:((User)->Void), otherwise:((PFUser?)->Void)) {
        println("User : checkCurrentUser")
        if let currentUser = PFUser.currentUser() {
            if PFFacebookUtils.isLinkedWithUser(currentUser) {
                User.getMe({ (me:User?) -> Void in
                    if let me = me {
                        onValidUser(me)
                    } else {
                        otherwise(currentUser)
                    }
                })
            } else {
                otherwise(currentUser)
            }
        } else {
            otherwise(nil)
        }
    }
    
    class func getMe(onComplete:((User?)->Void)){
        println("User : getMe")
        var request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, res:AnyObject!, err:NSError!) -> Void in
            if err == nil && res != nil {
                let userData = res as! NSDictionary
    
                let user = User(innerUser: PFUser.currentUser())
                user.email = userData["email"] as? String
                user.name = userData["name"] as? String
                user.firstName = userData["first_name"] as? String
                user.middleName = userData["middle_name"] as? String ?? ""
                user.lastName = userData["last_name"] as? String
                user.gender = userData["gender"] as? String ?? ""
                user.locale = userData["locale"] as? String ?? ""
                user.facebookId = userData["id"] as? String
                
                Friend.getAllFriendsFromFacebook(user.facebookId!, onComplete: { (friends:[Friend]?) -> Void in
                    user.numberOfConnections = friends?.count ?? 0
                    User.currentUser = user
                    onComplete(user)
                })
                
            } else {
                onComplete(nil)
            }
        }
    }
    
    
    
    class func getAllFacebookFriends(onComplete:(([Friend]?)->Void)){

    }
}