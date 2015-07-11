//
//  SettingsGeneralViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/9/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let settingsCellReuseIdentifier = "SettingsCell"
let logOutCellReuseIdentifier = "LogOutCell"

class SettingsGeneralViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogOut(sender: UIButton) {
        var notification = NSNotification(name: kUserDidLogOutNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }

    @IBAction func onDoneButton(sender: UIButton) {
        println("Done")
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        headerView.backgroundColor = UIColor.prettoBlue()
        profileImage.backgroundColor = UIColor.whiteColor()
        profileImage.contentMode = UIViewContentMode.ScaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 30
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
// MARK: UITableViewDelegate

extension SettingsGeneralViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 6 {
            
            let alert: UIAlertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.view.tintColor = UIColor.prettoOrange()
            let actionLogOut: UIAlertAction = UIAlertAction(title: "Yes, log me out!", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                var notification = NSNotification(name: kUserDidLogOutNotification, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
            let actionCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(actionLogOut)
            alert.addAction(actionCancel)
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
}

// MARK: UITableViewDataSource

extension SettingsGeneralViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ACCOUNT"
        case 1:
            return "GENERAL"
        case 2:
            return "NOTIFICATIONS"
        case 3:
            return "PRIVACY"
        case 4:
            return "SUPPORT"
        case 5:
            return "ABOUT"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
//        case 0:
//            return 3
//        case 1:
//            return 3
//        case 2:
//            return 1
//        case 3:
//            return 1
//        case 4:
//            return 2
//        case 5:
//            return 3
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier(logOutCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(settingsCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
    }
}