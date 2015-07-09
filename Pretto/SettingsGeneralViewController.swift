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
        snapshotOut.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        snapshotIn.frame = CGRect(x: -UIScreen.mainScreen().bounds.width, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        UIApplication.sharedApplication().keyWindow!.addSubview(snapshotOut)
        UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(snapshotOut)
        UIApplication.sharedApplication().keyWindow!.addSubview(snapshotIn)
        UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(snapshotIn)
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            snapshotOut.center = CGPoint(x: UIScreen.mainScreen().bounds.width * 1.5, y: UIScreen.mainScreen().bounds.height / 2)
            snapshotIn.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2)
            }) { (success:Bool) -> Void in
                if success {
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        snapshotOut.removeFromSuperview()
                        snapshotIn.removeFromSuperview()
                    })
                }
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
