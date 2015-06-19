//
//  ModelsIndex.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/19/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

func registerDataModels() {
    Event.registerSubclass()
    Friend.registerSubclass()
    Album.registerSubclass()
    Invitation.registerSubclass()
    Photo.registerSubclass()
    Request.registerSubclass()
    Notification.registerSubclass()
}