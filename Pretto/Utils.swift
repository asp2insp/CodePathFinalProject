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

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

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

// Animated Transitions

// Remember to remove snapshots from supperview in the completion block when calling this methods:
//
// animateFromLeftToRight(destinationVC, snapshotOut, snapshotIn) { (success) -> () in
//      self.dismissViewControllerAnimated(false, completion: { () -> Void in
//          snapshotIn.removeFromSuperview()
//          snapshotOut.removeFromSuperview()
//      }
// }
//
func animateFromRightToLeft(destinationViewController: UIViewController, initialSnapshot: UIView, finalSnapShot: UIView, completion: (success: Bool) -> ()) {
    initialSnapshot.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    finalSnapShot.frame = CGRect(x: UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    UIApplication.sharedApplication().keyWindow!.addSubview(initialSnapshot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(initialSnapshot)
    UIApplication.sharedApplication().keyWindow!.addSubview(finalSnapShot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(finalSnapShot)
    
    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        initialSnapshot.center = CGPoint(x: -(UIScreen.mainScreen().bounds.width / 2), y: UIScreen.mainScreen().bounds.height / 2)
        finalSnapShot.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
        }) { (success:Bool) -> Void in
            completion(success: success)
    }
}

func animateFromLeftToRight(destinationViewController: UIViewController, initialSnapshot: UIView, finalSnapShot: UIView, completion: (success: Bool) -> ()) {
    initialSnapshot.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    finalSnapShot.frame = CGRect(x: -UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    UIApplication.sharedApplication().keyWindow!.addSubview(initialSnapshot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(initialSnapshot)
    UIApplication.sharedApplication().keyWindow!.addSubview(finalSnapShot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(finalSnapShot)
    
    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        initialSnapshot.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 1.5, y: UIScreen.mainScreen().bounds.height / 2)
        finalSnapShot.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
        }) { (success:Bool) -> Void in
            completion(success: success)
    }
}

func animateShrink(destinationViewController: UIViewController, initialSnapshot: UIView, finalSnapShot: UIView, completion: (success: Bool) -> ()) {
    initialSnapshot.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    finalSnapShot.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    UIApplication.sharedApplication().keyWindow!.addSubview(finalSnapShot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(finalSnapShot)
    UIApplication.sharedApplication().keyWindow!.addSubview(initialSnapshot)
    UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(initialSnapshot)

    
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        initialSnapshot.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }) { (success:Bool) -> Void in
            completion(success: success)
    }
}