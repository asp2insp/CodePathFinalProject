//
//  CustomLandingViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/17/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class CustomLandingViewController: PFLogInViewController {
    
    private var signInButton: UIButton!
    private var gradientView: UIImageView!
    private var backgroundImage: UIImageView!
    private var otherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var signUpController = CustomSignUpViewController()
        signUpController.emailAsUsername = true
        signUpController.fields = .UsernameAndPassword | .SignUpButton | .DismissButton
        signUpController.delegate = self.delegate as? PFSignUpViewControllerDelegate
        self.signUpController = signUpController
        
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
        
        self.signInButton = UIButton()
        self.signInButton.titleLabel?.textColor = UIColor.whiteColor()
        self.signInButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.signInButton.titleLabel?.numberOfLines = 1
        self.signInButton.titleLabel?.font = self.signInButton.titleLabel?.font.fontWithSize(12)
        self.signInButton.addTarget(self, action: "onSignInButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.logInView?.addSubview(self.signInButton)
        
        self.logInView?.facebookButton?.setImage(nil, forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
        
        self.logInView?.signUpButton?.setImage(nil, forState: UIControlState.Normal)
        self.logInView?.signUpButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.logInView?.signUpButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.logInView?.signUpButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var screenWidth = self.view.frame.width
        var screenHeight = self.view.frame.height
        var logoHeight = CGFloat(98.0)
        var logoWidth = CGFloat(168.0)
        
        self.logInView?.logo?.frame = CGRect(x: (self.logInView!.frame.width - logoWidth) / 2.0, y: 50.0, width: logoWidth, height: logoHeight)
        
        self.gradientView.frame = CGRect(x: 0, y: self.logInView!.frame.height / 2, width: self.logInView!.frame.width, height: self.logInView!.frame.height / 2)
        
        self.backgroundImage.frame = self.logInView!.frame
        
        self.otherImage.frame = CGRect(x: 0, y: 0, width: 236, height: 107)
        self.otherImage.center = self.logInView!.center
        
        self.signInButton.frame = CGRect(x: self.logInView!.facebookButton!.frame.origin.x, y: self.logInView!.facebookButton!.frame.origin.y - 60, width: self.logInView!.facebookButton!.frame.width, height: self.logInView!.facebookButton!.frame.height)
        self.signInButton.setTitle("Already have and account? Sign in", forState: UIControlState.Normal)
        self.signInButton.center = CGPoint(x: self.signInButton.center.x, y: self.logInView!.frame.height - self.signInButton.frame.height / 2 - 16)
        
        self.logInView?.signUpButton?.layer.borderColor = UIColor.whiteColor().CGColor
        self.logInView?.signUpButton?.layer.borderWidth = 1
        self.logInView?.signUpButton?.layer.cornerRadius = self.logInView!.signUpButton!.frame.height / 2
        self.logInView?.signUpButton?.setTitle("Sign up with email", forState: UIControlState.Normal)
        self.logInView?.signUpButton?.setTitle("Sign up with email", forState: UIControlState.Highlighted)
        self.logInView?.signUpButton?.center = CGPoint(x: self.logInView!.signUpButton!.center.x, y: self.signInButton.center.y - self.logInView!.signUpButton!.frame.height)
        
        self.logInView?.facebookButton?.layer.borderColor = UIColor.whiteColor().CGColor
        self.logInView?.facebookButton?.layer.borderWidth = 1
        self.logInView?.facebookButton?.layer.cornerRadius = self.logInView!.facebookButton!.frame.height / 2
        self.logInView?.facebookButton?.titleLabel?.frame = self.logInView!.facebookButton!.titleLabel!.superview!.frame
        self.logInView?.facebookButton?.setTitle("Continue with Facebook", forState: UIControlState.Normal)
        self.logInView?.facebookButton?.setTitle("Continue with Facebook", forState: UIControlState.Highlighted)
        self.logInView?.facebookButton?.center = CGPoint(x: self.logInView!.facebookButton!.center.x, y: self.logInView!.signUpButton!.center.y - self.logInView!.facebookButton!.frame.height - 16)
        
        
        
        
    }
    
    func onSignInButton() {
        var notification = NSNotification(name: kShowLoginWindowNotification, object: nil)
        
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
