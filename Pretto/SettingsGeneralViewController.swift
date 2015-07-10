//
//  SettingsGeneralViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/9/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    
    @IBAction func onLogOut(sender: UIButton) {
        var notification = NSNotification(name: kUserDidLogOutNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }

    @IBAction func onBackButton(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = self.presentingViewController as! UITabBarController
        let snapshotOut = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)
        let snapshotIn = destinationVC.view.snapshotViewAfterScreenUpdates(true)
        animateFromLeftToRight(destinationVC, snapshotOut, snapshotIn) { (success) -> () in
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                snapshotIn.removeFromSuperview()
                snapshotOut.removeFromSuperview()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = UIColor.prettoBlue()
        // Do any additional setup after loading the view.
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
