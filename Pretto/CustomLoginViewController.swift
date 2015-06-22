//
//  CustomLoginViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/17/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class CustomLoginViewController: PFLogInViewController {
    
    private var gradientView: UIImageView!
    private var backgroundImage: UIImageView!
    private var otherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInView?.dismissButton?.addTarget(self, action: "onDismissButton", forControlEvents: UIControlEvents.TouchUpInside)

        self.logInView?.logo = UIImageView(image: UIImage(named: "LauchScreenLogo2")!)
        
        self.backgroundImage = UIImageView()
        self.backgroundImage.backgroundColor = UIColor.prettoBlue()
        //        self.backgroundImage.image = UIImage(named: "friends_7")
        self.logInView?.addSubview(backgroundImage)
        self.logInView?.sendSubviewToBack(backgroundImage)
        
        self.otherImage = UIImageView()
        self.otherImage.image = UIImage(named: "LaunchScreenThingy")
        self.logInView?.addSubview(otherImage)

        self.gradientView = UIImageView(image: UIImage(named: "gradient"))
        self.logInView?.addSubview(self.gradientView)
        self.logInView?.sendSubviewToBack(self.gradientView)

        self.logInView?.usernameField?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
        self.logInView?.usernameField?.textColor = UIColor.whiteColor()
        self.logInView?.passwordField?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
        self.logInView?.passwordField?.textColor = UIColor.whiteColor()

        self.logInView?.logInButton?.titleLabel?.font = self.logInView?.logInButton!.titleLabel?.font.fontWithSize(17)
        self.logInView?.logInButton?.backgroundColor = UIColor.clearColor()
        self.logInView?.logInButton?.setImage(nil, forState: UIControlState.Normal)
        self.logInView?.logInButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.logInView?.logInButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView?.logInButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        
        self.logInView?.facebookButton?.setImage(nil, forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)

        self.logInView?.passwordForgottenButton?.backgroundColor = UIColor.clearColor()
        self.logInView?.passwordForgottenButton?.setImage(nil, forState: UIControlState.Normal)
        self.logInView?.passwordForgottenButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.logInView?.passwordForgottenButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView?.passwordForgottenButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.logInView?.passwordForgottenButton?.titleLabel?.font = UIFont.systemFontOfSize(12)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.logInView?.usernameField?.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.logInView?.passwordField?.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        println("Email Text Field size \(self.logInView!.usernameField!.frame.width) x \(self.logInView!.usernameField!.frame.height)")
        println("Email Text Field x: \(self.logInView!.usernameField!.frame.origin.x) y: \(self.logInView!.usernameField!.frame.origin.y)")

        println("Password Text Field size \(self.logInView!.passwordField!.frame.width) x \(self.logInView!.passwordField!.frame.height)")
        println("Password Text Field x: \(self.logInView!.passwordField!.frame.origin.x) y: \(self.logInView!.passwordField!.frame.origin.y)")
        var screenWidth = self.view.frame.width
        var screenHeight = self.view.frame.height
        var logoHeight = CGFloat(98.0)
        var logoWidth = CGFloat(168.0)

        self.logInView?.logo?.frame = CGRect(x: (self.logInView!.frame.width - logoWidth) / 2.0, y: 50.0, width: logoWidth, height: logoHeight)
        
        self.gradientView.frame = CGRect(x: 0, y: self.logInView!.frame.height / 2, width: self.logInView!.frame.width, height: self.logInView!.frame.height / 2)
        
        self.backgroundImage.frame = self.logInView!.frame
        
        self.otherImage.frame = CGRect(x: 0, y: 0, width: 236, height: 107)
        self.otherImage.center = CGPoint(x: self.logInView!.center.x, y: self.logInView!.center.y + 60)

        self.logInView?.usernameField?.center = CGPoint(x: self.logInView!.usernameField!.center.x, y: self.logInView!.usernameField!.center.y - 40)
        self.logInView?.passwordField?.center = CGPoint(x: self.logInView!.passwordField!.center.x, y: self.logInView!.passwordField!.center.y - 40)

        self.logInView?.passwordForgottenButton?.center = CGPoint(x: self.logInView!.passwordField!.center.x, y: self.logInView!.passwordField!.center.y + 40)
        self.logInView?.passwordForgottenButton?.titleLabel?.textColor = UIColor.whiteColor()
        
        self.logInView?.facebookButton?.layer.borderColor = UIColor.whiteColor().CGColor
        self.logInView?.facebookButton?.layer.borderWidth = 2
        self.logInView?.facebookButton?.layer.cornerRadius = self.logInView!.facebookButton!.frame.height / 2
        self.logInView?.facebookButton?.titleLabel?.frame = self.logInView!.facebookButton!.titleLabel!.superview!.frame
        self.logInView?.facebookButton?.setTitle("Continue with Facebook", forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setTitle("Continue with Facebook", forState: UIControlState.Highlighted)
        self.logInView?.facebookButton?.frame = CGRect(x: 16, y: self.logInView!.frame.height - 104, width: self.logInView!.facebookButton!.frame.width, height: self.logInView!.facebookButton!.frame.height)
            //center = CGPoint(x: self.logInView!.facebookButton!.center.x, y: self.logInView!.frame.height - 60)
        
        self.logInView?.logInButton?.frame = CGRect(x: self.logInView!.logInButton!.frame.origin.x + 16, y: self.logInView!.facebookButton!.frame.origin.y - 60, width: self.logInView!.logInButton!.frame.width - 32, height: 44)
        self.logInView?.logInButton?.layer.borderColor = UIColor.whiteColor().CGColor
        self.logInView?.logInButton?.layer.borderWidth = 2
        self.logInView?.logInButton?.layer.cornerRadius = self.logInView!.logInButton!.frame.height / 2
        self.logInView?.logInButton?.setTitle("Log In with email", forState: UIControlState.Normal)
        self.logInView?.logInButton?.setTitle("Log In with email", forState: UIControlState.Highlighted)
    
    }
    
    func onDismissButton() {
        var notification = NSNotification(name: kShowLandingWindowNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
