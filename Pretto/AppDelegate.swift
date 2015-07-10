//
//  AppDelegate.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/3/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let dateFormatter = NSDateFormatter()
let kTextFieldDidChangeNotification = "UITextFieldTextDidChangeNotification"
let kNewPhotoForEventNotification = "PrettoNewPhotoForEvent"
let kUserDidLogOutNotification = "userDidLogOut"
let kShowLoginWindowNotification = "showLoginWindow"
let kShowLandingWindowNotification = "showLandingWindow"
let kIntroDidFinishNotification = "introIsOver"
let kShareOnFacebookNotification = "shareOnFacebook"
let kShareOnTwitterNotification = "shareOnTwitter"
let kShareByEmailNotification = "shareByEmail"
let kAcceptEventAndDismissVCNotification = "acceptEventAndDismissVC"
let kFirstTimeRunningPretto = "isTheFirstTimeEver"
let kDidPressCreateEventNotification = "createNewEvent"
let kUserDidPressCameraNotification = "openCamera"

let cameraView: UIImageView = UIImageView()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var window: UIWindow? = UIWindow(frame:UIScreen.mainScreen().bounds)
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var isTheFirstTimeEver = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("didFinishLaunchingWithOptions")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLoginWindow", name: kShowLoginWindowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLandingWindow", name: kShowLandingWindowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "introDidFinish", name: kIntroDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogOut", name: kUserDidLogOutNotification, object: nil)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        GlobalAppearance.setAll()
        registerDataModels()

        // Initialize Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId("EwtAHVSdrZseylxvkalCaMQ3aTWknFUgnhJRcozx", clientKey: "kA7v5dqEEndRpZgcOsL2G4jitdGuPzj63xmYm7xZ")
        PFUser.enableRevocableSessionInBackground()
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

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
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: { (success:Bool, error:NSError?) -> Void in
                    if !success {
                        ParseErrorHandlingController.handleParseError(error!)
                    }
                })
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
        
        application.setMinimumBackgroundFetchInterval(30)
        
        // check user and start a storyboard accordingly
        let isFirstTime: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(kFirstTimeRunningPretto) as? Bool
        if  isFirstTime == nil || isFirstTime == true {
            self.showIntroWindow()
        } else {
            self.showTransitionScreen()
            self.checkCurrentUser()
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken")
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("didFailToRegisterForRemoteNotificationsWithError")
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("AppDelegate : didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            println("AppDelegate : openURL")
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // TODO - upload new pictures here
        println("AppDelegate : performFetchWithCompletionHandler")
        completionHandler(UIBackgroundFetchResult.NewData)
    }

    func applicationWillResignActive(application: UIApplication) {
        println("AppDelegate : applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("AppDelegate : applicationDidEnterBackground")
        var currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        println("AppDelegate : applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        var currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        println("AppDelegate : deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kShowLoginWindowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kShowLandingWindowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kIntroDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserDidLogOutNotification, object: nil)
        var currentInstallation = PFInstallation.currentInstallation()
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
        
    }
    
}

//MARK: Auxiliary Functions

extension AppDelegate {
    
    func addCameraOverlay() {
        var window = UIApplication.sharedApplication().keyWindow
        let iconSize = CGSize(width: 56.0, height: 56.0)
        let margin = CGFloat(8.0)
        window?.addSubview(cameraView)
        window?.bringSubviewToFront(cameraView)
        cameraView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: iconSize)
        cameraView.backgroundColor = UIColor.clearColor()
        cameraView.image = UIImage(named: "OverlayCameraButtonOrange")
        cameraView.center = CGPoint(x: window!.bounds.width - (iconSize.width / 2) - margin, y: window!.bounds.height - (iconSize.height / 2) - margin - 51)
        cameraView.userInteractionEnabled = true
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedOnCamera")
        cameraView.addGestureRecognizer(tapRecognizer)
    }
    
    func tappedOnCamera() {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kUserDidPressCameraNotification, object: nil))
    }
    
    func checkCurrentUser() {
        println("AppDelegate: checkCurrentUser")
        User.checkCurrentUser({ (user: User) -> Void in
            println("Saving user details...")
            user.save()
            user.printProperties()
            self.fetchFriends(user)
            self.startMainStoryBoard()

            },
            otherwise: { (pfUser: PFUser?) -> Void in
                if let pfUser = pfUser {
                    println("Unlinking user from FB")
                    PFFacebookUtils.unlinkUserInBackground(pfUser)
                }
                self.showLandingWindow()
        })
    }
    
    func fetchFriends(user:User) {
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
    }
    
    func userDidLogOut() {
        PFUser.logOut()
        (UIApplication.sharedApplication().delegate as! AppDelegate).showLandingWindow()
    }
    
    func introDidFinish() {
        println("introDidFinish")
        self.checkCurrentUser()
    }
    
    func showTransitionScreen() {
        var transitionViewController = storyboard.instantiateViewControllerWithIdentifier("TransitionViewController") as! TransitionViewController
        self.window!.rootViewController = transitionViewController
        self.window!.makeKeyAndVisible()
    }
    
    func showIntroWindow() {
        println("AppDelegate : showIntroWindow")
        var introViewController = storyboard.instantiateViewControllerWithIdentifier("IntroViewController") as! IntroViewController
        self.window!.rootViewController = introViewController
        self.window!.makeKeyAndVisible()
    }
    
    func showLandingWindow() {
        println("AppDelegate : Show Landing Notification Received")
        var landingViewController = CustomLandingViewController()
        landingViewController.fields = .Facebook | .SignUpButton
        landingViewController.delegate = self
        self.window!.rootViewController = landingViewController
        self.window!.makeKeyAndVisible()
    }
    
    func showLoginWindow() {
        println("AppDelegate : Show Login Notification Received")
        var logInViewController = CustomLoginViewController()
        logInViewController.fields = .Facebook | .UsernameAndPassword | .PasswordForgotten | .LogInButton | .DismissButton
        logInViewController.delegate = self
        logInViewController.emailAsUsername = true
        self.window!.rootViewController = logInViewController
        self.window!.makeKeyAndVisible()
    }
    
    func startMainStoryBoard() {
        println("AppDelegate : startMainStoryBoard")
        let destinationVC = storyboard.instantiateInitialViewController() as! UITabBarController
        destinationVC.selectedIndex = 1
        
        if let transitionViewController = self.window!.rootViewController as? TransitionViewController {
            transitionViewController.startAnimation { (success) -> Void in
                if success {
                    println("MARCA 2")
                    let snapshotOut = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)
                    let snapshotIn = destinationVC.view.snapshotViewAfterScreenUpdates(true)
                    
                    animateShrink(destinationVC, snapshotOut, snapshotIn, { (success) -> () in
                        snapshotOut.removeFromSuperview()
                        snapshotIn.removeFromSuperview()
                        self.window!.rootViewController = destinationVC
                        self.window!.makeKeyAndVisible()
                        self.addCameraOverlay()
                    })
                }
            }
        } else {
            let snapshotOut = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)
            let snapshotIn = destinationVC.view.snapshotViewAfterScreenUpdates(true)
            
            animateFromRightToLeft(destinationVC, snapshotOut, snapshotIn, { (success) -> () in
                snapshotOut.removeFromSuperview()
                snapshotIn.removeFromSuperview()
                self.window!.rootViewController = destinationVC
                self.window!.makeKeyAndVisible()
                self.addCameraOverlay()
            })
        }
    }
}

//MARK: PFSignUpViewControllerDelegate {

extension AppDelegate: PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        println("Sign Up is Done")
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        self.startMainStoryBoard()
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("User did cancel Sign Up")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("Error while signing up new user. Error: \(error)")
    }
}

//MARK: PFLogInViewControllerDelegate {

extension AppDelegate: PFLogInViewControllerDelegate {
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        println("FB login is done")
        // Add a pointer to the current User in the Current Installation to send targeted Push Notif
        // Associate the device with a user
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
        
        // Handles the very first time a user logs in
        let isFirstTime: Bool? = NSUserDefaults.standardUserDefaults().objectForKey(kFirstTimeRunningPretto) as? Bool
        
        if  isFirstTime == nil || isFirstTime == true {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: kFirstTimeRunningPretto)
            logInController.dismissViewControllerAnimated(true, completion: nil)
            self.checkCurrentUser()
        } else {
            logInController.dismissViewControllerAnimated(true, completion: nil)
            self.startMainStoryBoard()
        }
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        println("User did cancel Sign Up")
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Error while loging in new user. Error: \(error)")
    }
}
