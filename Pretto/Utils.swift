//
//  Utils.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/23/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

let titleForCachingImagesQueue = "co.twisterlabs.Pretto.caching"

var GlobalMainQueue: dispatch_queue_t {
    return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)
}

var CustomImageCachingQueue: dispatch_queue_t {
    return dispatch_queue_create(titleForCachingImagesQueue, DISPATCH_QUEUE_CONCURRENT)
}

// Auxiliary Functions
func printAppStatus() {
    switch UIApplication.sharedApplication().applicationState {
    case .Active:
        println("UIApplicationState = Active")
    case .Inactive:
        println("UIApplicationState = Inactive")
    case .Background:
        println("UIApplicationState = Background")
    default:
        println("UIApplicationState = Unknown")
    }
}

func printBackgroundRefreshStatus() {
    switch UIApplication.sharedApplication().backgroundRefreshStatus {
    case .Available:
        println("UIBackgroundRefreshStatus = Active")
    default:
        println("UIBackgroundRefreshStatus = Restricted or Denied")
    }
}

func printBackgroundRemainingTime() {
    println("Application BackgroundTimeRemaining: \(UIApplication.sharedApplication().backgroundTimeRemaining)")
}