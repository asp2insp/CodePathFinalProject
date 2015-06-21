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
//        println(self.email)
//        println(self.name)
//        println(self.profilePhotoUrl)
    }
    
    func save() {
        self.inner.saveEventually()
    }
    
    class func checkCurrentUser(onValidUser:((User)->Void), otherwise:((PFUser?)->Void)) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            if PFFacebookUtils.isLinkedWithUser(currentUser!) {
                User.getMe({ (me:User?) -> Void in
                    if me != nil {
                        onValidUser(me!)
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
        var request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, res:AnyObject!, err:NSError!) -> Void in
            if err == nil && res != nil {
                var userData = res as! NSDictionary
                
                var facebookId = userData["id"] as! String
                var email = userData["email"] as! String?
                var name = userData["name"] as! String
                var firstName = userData["first_name"] as! String
                var middleName = userData["middle_name"] as? String ?? ""
                var lastName = userData["last_name"] as! String
                var gender = userData["gender"] as? String ?? ""
                var locale = userData["locale"] as? String ?? ""
                
                var currentUser = PFUser.currentUser()
                var user = User(innerUser: currentUser)
                user.facebookId = facebookId
                user.email = email
                user.name = name
                user.firstName = firstName
                user.middleName = middleName
                user.lastName = lastName
                user.gender = gender
                user.locale = locale
                
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