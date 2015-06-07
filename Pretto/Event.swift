//
//  Event.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation
private let kNameKey = "name"
private let kOwnerKey = "owner"

class Event {
    private static let kClassName = "Event"

    private var storage : BackendObject = BackendObject(className: kClassName)
    
    var name : String? {
        set { storage.setValue(name, forKey: kNameKey) }
        get { return storage[kNameKey] as? String ?? nil }
    }
    
    var owner : BackendUser? {
        set { storage.setValue(owner, forKey: kOwnerKey) }
        get { return storage[kOwnerKey] as? BackendUser ?? nil }
    }
}