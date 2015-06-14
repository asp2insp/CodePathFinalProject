//
//  ViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/3/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logInWithFacebookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = BackendUser.currentUser() {
            println("Current User: \(user.description)")
        } else {
            println("No logged in user")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didTapLogIn(sender: UIButton) {
        let permissions = ["public_profile", "email", "user_friends"]
        switch sender {
        case logInWithFacebookButton:
            PFFacebookUtils.logInWithPermissions(permissions) {
                (user: PFUser?, error: NSError?) -> Void in
                self.performSegueWithIdentifier("finishLogIn", sender: self)
                println("Finished login flow")
                if let error = error {
                    println("Error: \(error)")
                } else if let user = user {
                    if user.isNew {
                        println("User signed up and logged in through Facebook!")
                    } else {
                        println("User logged in through Facebook!")
                    }
                } else {
                    println("Uh oh. The user cancelled the Facebook login.")
                }
            }
        default:
            return
        }
    }
}

