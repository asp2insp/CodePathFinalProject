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
    
    func save() {
        self.inner.save()
    }
}