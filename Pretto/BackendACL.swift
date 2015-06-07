//
//  BackendACL.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/6/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class BackendACL : PFACL {
    // This class serves as a wrapper class for a access control list
    // persisted to the backend. If/when we move away from Parse,
    // this class should be changed to inherit from the new backend
    // implementation.
    
    init(user: BackendUser) {
        super.init(user: user as PFUser)
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
    }
}