//
//  ViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/3/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class LoginViewController: PFLogInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPrettoLogo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            println("Current User: \(user.description)")
        } else {
            println("No logged in user")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPrettoLogo() {
        var logoImage = UIImageView(frame:CGRectMake(0, 0, 300, 72))
        logoImage.image = UIImage(named: "pretto")
        
        var logoView = UIView(frame:CGRectMake(0, 0, 300, 72))
        logoView.addSubview(logoImage)
        
        let xConstraint = NSLayoutConstraint(
            item: logoImage,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: logoView,
            attribute: .CenterX,
            multiplier: 1,
            constant: 0)
        
        logoView.addConstraint(xConstraint)
        logInView?.logo = logoView
    }
}

