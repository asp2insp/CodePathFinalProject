//
//  CustomSignUpViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/17/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class CustomSignUpViewController: PFSignUpViewController {
    
    private var blurEffectView: UIVisualEffectView!
    private var gradientView: UIImageView!
    private var backgroundImage: UIImageView!
    private var otherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpView?.logo = UIImageView(image: UIImage(named: "LauchScreenLogo2")!)
        
        self.backgroundImage = UIImageView()
        self.backgroundImage.backgroundColor = UIColor.prettoBlue()
        self.signUpView?.addSubview(backgroundImage)
        self.signUpView?.sendSubviewToBack(backgroundImage)
        
        self.otherImage = UIImageView()
        self.otherImage.image = UIImage(named: "LaunchScreenThingy")
        self.signUpView?.addSubview(otherImage)
        
        self.signUpView?.dismissButton?.setImage(UIImage(named: "CloseButton"), forState: UIControlState.Normal)
        self.signUpView?.dismissButton?.setImage(UIImage(named: "CloseButton"), forState: UIControlState.Highlighted)
        
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        self.gradientView = UIImageView(image: UIImage(named: "gradient"))
        self.signUpView?.addSubview(self.gradientView)
        self.signUpView?.sendSubviewToBack(self.gradientView)
    
        self.signUpView?.usernameField?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
        self.signUpView?.usernameField?.textColor = UIColor.whiteColor()

        self.signUpView?.passwordField?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
        self.signUpView?.passwordField?.textColor = UIColor.whiteColor()
        
        self.signUpView?.signUpButton?.titleLabel?.font = self.signUpView?.signUpButton!.titleLabel?.font.fontWithSize(17)
        
        self.signUpView?.signUpButton?.setImage(nil, forState: UIControlState.Normal)
        self.signUpView?.signUpButton?.setImage(nil, forState: UIControlState.Highlighted)
        self.signUpView?.signUpButton?.setBackgroundImage(nil, forState: UIControlState.Normal)
        self.signUpView?.signUpButton?.setBackgroundImage(nil, forState: UIControlState.Highlighted)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.signUpView?.usernameField?.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.signUpView?.passwordField?.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var screenWidth = self.view.frame.width
        var screenHeight = self.view.frame.height
        var logoHeight = CGFloat(98.0)
        var logoWidth = CGFloat(168.0)
        
        self.signUpView?.usernameField?.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.signUpView?.passwordField?.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        self.blurEffectView.frame = CGRect(x: self.signUpView!.usernameField!.frame.origin.x, y: self.signUpView!.usernameField!.frame.origin.y, width: self.signUpView!.usernameField!.frame.width, height: self.signUpView!.usernameField!.frame.height * 2)
        
        self.signUpView?.logo?.frame = CGRect(x: (self.signUpView!.frame.width - logoWidth) / 2.0, y: 50.0, width: logoWidth, height: logoHeight)
        
        self.gradientView.frame = CGRect(x: 0, y: self.signUpView!.frame.height / 2, width: self.signUpView!.frame.width, height: self.signUpView!.frame.height / 2)
        
        self.backgroundImage.frame = self.signUpView!.frame
        
        self.otherImage.frame = CGRect(x: 0, y: 0, width: 236, height: 107)
        self.otherImage.center = CGPoint(x: self.signUpView!.center.x, y: self.signUpView!.center.y + 100)
        
        self.signUpView?.usernameField?.center = CGPoint(x: self.signUpView!.usernameField!.center.x, y: self.signUpView!.usernameField!.center.y - 80)
        self.signUpView?.passwordField?.center = CGPoint(x: self.signUpView!.passwordField!.center.x, y: self.signUpView!.passwordField!.center.y - 80)
        
        self.signUpView?.signUpButton?.layer.cornerRadius = self.signUpView!.signUpButton!.frame.height / 2
        self.signUpView?.signUpButton?.setTitle("Sign up with email", forState: UIControlState.Normal)
        self.signUpView?.signUpButton?.setTitle("Sign up with email", forState: UIControlState.Highlighted)
        self.signUpView?.signUpButton?.frame = CGRect(x: self.signUpView!.signUpButton!.frame.origin.x + 16, y: self.signUpView!.frame.height - 104, width: self.signUpView!.frame.width - 32, height: 44)
        self.signUpView?.signUpButton?.layer.borderColor = UIColor.whiteColor().CGColor
        self.signUpView?.signUpButton?.layer.borderWidth = 1
        self.signUpView?.signUpButton?.layer.cornerRadius = self.signUpView!.signUpButton!.frame.height / 2
        
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
