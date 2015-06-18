//
//  EventManager.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/16/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//



// DO NOT PAY ATTENTION TO THIS. THIS CLASS IS ONLY FOR TESTING
import UIKit


class EventManager: NSObject {
    
    typealias createEventCompletion = (success: Bool, userInvitation: Invitation, intitationsSent: [Invitation]?) -> ()
    
    
    
    func createEvent(dictionary: NSDictionary, completion: createEventCompletion) {
        //Create Event and the associated Album. It aslo create (calls XXXX) and send Invitation objects (calls XXXX ) for every Guest.
    }
    
    func createAlbumForEvent(event: Event) {
        
    }
    
    func createOwnerInvitationForEvent(event: Event, owner: User) {
        
    }
    
    func createGuestInviationForEvent(event: Event, guest: User) {
        
    }
    
    func createGuestInviationsWithArray(event: Event, guests: [User]) {
        
    }

}
