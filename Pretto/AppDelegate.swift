//
//  AppDelegate.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/3/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let dateFormatter = NSDateFormatter()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Invitation.registerSubclass()
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("EwtAHVSdrZseylxvkalCaMQ3aTWknFUgnhJRcozx",
            clientKey: "kA7v5dqEEndRpZgcOsL2G4jitdGuPzj63xmYm7xZ")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        application.setMinimumBackgroundFetchInterval(60 * 60)
        
        // Register for Push Notitications
        self.registerForRemoteNotifications(application, launchOptions:launchOptions)
        
        // check user and start a storyboard accourdingly
        self.checkCurrentUser({ (user:User) -> Void in
                user.save()
                user.printProperties()
                println("Save user details invoked")
                self.startMainStoryBoard()
            
                Friend.getAllFriendsFromFacebook(user.facebookId!, onComplete: { (friends:[Friend]?) -> Void in
                    if friends != nil {
                        println("Friends retrieved from FB")
                        Friend.printDebugAll(friends!)
                        Friend.getAllFriendsFromDBase(user.facebookId!, onComplete: { (savedFriends:[Friend]?) -> Void in
                            if savedFriends != nil {
                                var unsavedFriends = Friend.subtract(friends!, from: savedFriends!)
                                if unsavedFriends.count > 0 {
                                    Friend.saveAllInBackground(unsavedFriends)
                                    println("Saving friends invoked for \(unsavedFriends.count)")
                                } else {
                                    println("Friends are up to date.")
                                }
                            } else {
                                println("No friends are saved yet. Attempting to save all.")
                                Friend.saveAllInBackground(friends!)
                                println("Saving friends invoked for \(friends!.count)")
                            }
                        })
                    } else {
                        println("No FB friends using this app")
                    }
                })
            
            },
            otherwise: { (pfUser:PFUser?) -> Void in
                if pfUser != nil {
                    PFFacebookUtils.unlinkUserInBackground(pfUser!)
                }
                self.showLoginWindow()
            })
        
        return false
    }
    
    func checkCurrentUser(onValidUser:((User)->Void), otherwise:((PFUser?)->Void)) {
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            if PFFacebookUtils.isLinkedWithUser(currentUser!) {
                User.getMe({ (me:User?) -> Void in
                    if me != nil {
                        onValidUser(me!)
                    } else {
                        otherwise(currentUser)
                    }
                })
            } else {
                otherwise(currentUser)
            }
        } else {
            otherwise(nil)
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        println("FB login is done")
        self.startMainStoryBoard()
    }
    
    func registerForRemoteNotifications(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
                
            }
        }
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
        println("Remote Notification Received!")
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // TODO - upload new pictures here
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func showLoginWindow() {
        var logInController = LoginViewController()
        logInController.fields = .Facebook
        logInController.delegate = self;
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = logInController
        self.window!.makeKeyAndVisible()
    }
    
    func startMainStoryBoard() {
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        var mainSB = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainSB.instantiateInitialViewController() as! UITabBarController
        viewController.selectedIndex = 1
        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
    }
}

