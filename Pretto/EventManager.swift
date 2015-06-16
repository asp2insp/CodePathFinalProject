//
//  EventManager.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/16/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit


class EventManager: NSObject {
    
    typealias createEventCompletion = (success: Bool, userInvitation: Invitation, intitationsSent: [Invitation]?) -> ()
    
    func createEvent(dictionary: NSDictionary, completion: createEventCompletion) {
        
    }

}
