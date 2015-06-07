//
//  Event.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

private let kClassName = "Event"
private let kNameKey = "name"
private let kOwnerKey = "owner"

class Event : BackendObject {
    override init() {
        super.init(className: kClassName)
    }
    
    var name : String? {
        set { setValue(name, forKey: kNameKey) }
        get { return self[kNameKey] as? String ?? nil }
    }
    
    var owner : BackendUser? {
        set { setValue(owner, forKey: kOwnerKey) }
        get { return self[kOwnerKey] as? BackendUser ?? nil }
    }
}