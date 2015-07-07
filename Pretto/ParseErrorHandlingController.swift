//
//  ParseErrorHandlingController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/7/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class ParseErrorHandlingController {
    class func handleParseError(error: NSError) {
        if error.domain != PFParseErrorDomain {
            return
        }
        
        switch (error.code) {
        case 209://kPFErrorInvalidSessionToken:
            handleInvalidSessionTokenError()
        default:
            println("other error code: \(error.code)")
        }
    }
    
    private class func handleInvalidSessionTokenError() {
        println("WRONG SESSION TOKEN, DO SOMETHING! ")
        var notification = NSNotification(name: kUserDidLogOutNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
            //--------------------------------------
            // Option 1: Show a message asking the user to log out and log back in.
            //--------------------------------------
            // If the user needs to finish what they were doing, they have the opportunity to do so.
            //
            // let alertView = UIAlertView(
            //   title: "Invalid Session",
            //   message: "Session is no longer valid, please log out and log in again.",
            //   delegate: nil,
            //   cancelButtonTitle: "Not Now",
            //   otherButtonTitles: "OK"
            // )
            // alertView.show()
            
            //--------------------------------------
            // Option #2: Show login screen so user can re-authenticate.
            //--------------------------------------
            // You may want this if the logout button is inaccessible in the UI.
            //
            // let presentingViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            // let logInViewController = PFLogInViewController()
            // presentingViewController?.presentViewController(logInViewController, animated: true, completion: nil)
    }
}
