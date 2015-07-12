//
//  NotificationsViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/20/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class NotificationsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, InvitationActionDelegate, RequestActionDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notifications : [Notification] = []
    var upcomingInvitations : [Invitation] = []
    // Requests are grouped by user
    var requests : [[Request]] = []
    
    var refreshControl : UIRefreshControl!
    var refreshCount = 0
    
    private let emptyBackgroundView = UIView(frame: UIScreen.mainScreen().bounds)
    private let emptyNotificationsView = UIImageView(image: UIImage(named: "NotificationsEmptyCircle2"))
    
    @IBAction func onSettingsButton(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewControllerWithIdentifier("SettingsGeneralViewController") as! SettingsGeneralViewController
        let snapshotOut = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)
        let snapshotIn = destinationVC.view.snapshotViewAfterScreenUpdates(true)
        animateFromRightToLeft(destinationVC, snapshotOut, snapshotIn) { (success) -> () in
            self.presentViewController(destinationVC, animated: false, completion: { () -> Void in
                snapshotOut.removeFromSuperview()
                snapshotIn.removeFromSuperview()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        emptyNotificationsView.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        emptyBackgroundView.addSubview(emptyNotificationsView)
        emptyBackgroundView.bringSubviewToFront(emptyNotificationsView)
        emptyNotificationsView.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2 - 50)
        tableView.backgroundView = emptyBackgroundView
        
        self.tableView.estimatedRowHeight = 78
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
//        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        refreshData()
    }
    
    func refreshData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.activityIndicatorColor = UIColor.whiteColor()
        hud.color = UIColor.prettoBlue().colorWithAlphaComponent(0.75)
        dispatch_async(GlobalMainQueue) {
            self.refreshCount += 3
            Notification.getAll() {notifications in
                if let notifications = notifications {
                    self.notifications = notifications
                    if --self.refreshCount == 0 {
                        println("Notifications \(self.notifications.count)")
                        if self.notifications.count > 0 || self.upcomingInvitations.count > 0 || self.requests.count > 0 {
                            self.emptyNotificationsView.hidden = true
                        } else {
                            self.emptyNotificationsView.hidden = false
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                    }
                }
            }
            Invitation.getAllLiveAndFutureNonAcceptedEvents() {invites in
                self.upcomingInvitations = invites
                if --self.refreshCount == 0 {
                    println("upcomingInvitations \(self.upcomingInvitations.count)")
                    if self.notifications.count > 0 || self.upcomingInvitations.count > 0 || self.requests.count > 0 {
                        self.emptyNotificationsView.hidden = true
                    } else {
                        self.emptyNotificationsView.hidden = false
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
            }
            
            Request.getAllPendingRequests() {requests in
                if let requests = requests {
                    self.requests = self.groupByRequester(requests)
                    if --self.refreshCount == 0 {
                        println("requests \(self.requests.count)")
                        if self.notifications.count > 0 || self.upcomingInvitations.count > 0 || self.requests.count > 0 {
                            self.emptyNotificationsView.hidden = true
                        } else {
                            self.emptyNotificationsView.hidden = false
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func groupByRequester(reqs: [Request]) -> [[Request]] {
        var byUser : [PFUser:[Request]] = [:]
        for request in reqs {
            let user = request.requester
            if byUser[user] == nil {
                byUser[user] = []
            }
            byUser[user]!.append(request)
        }
        var grouped : [[Request]] = []
        for (_, group) in byUser {
            grouped.append(group)
        }
        return grouped
    }
    
    func hasAnyTableData() -> Bool {
        if self.notifications.count > 0 {
            return true
        }
        if self.upcomingInvitations.count > 0 {
            return true
        }
        if self.requests.count > 0 {
            return true
        }
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
        // return self.hasAnyTableData() ? 3 : 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return self.upcomingInvitations.count > 0 ? "Event Invitations" : nil
        case 1:
            return self.requests.count > 0 ? "Photo Requests" : nil
        case 2:
            return self.notifications.count > 0 ? "Other Notifications" : nil
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.upcomingInvitations.count
        case 1:
            return self.requests.count
        case 2:
            return self.notifications.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("invitation.cell", forIndexPath: indexPath) as! InvitationCell
            cell.invitation = self.upcomingInvitations[indexPath.row]
            cell.delegate = self
            return fixRowLine(cell)
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("request.cell", forIndexPath: indexPath) as! RequestCell
            cell.requests = self.requests[indexPath.row]
             cell.delegate = self
            return fixRowLine(cell)
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("notificationcell", forIndexPath: indexPath) as! NotificationCell
            cell.notification = self.notifications[indexPath.row]
            return fixRowLine(cell)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            switch indexPath.section {
            case 0:
                var invitation = self.upcomingInvitations[indexPath.row]
                invitation.deleteInBackground()
                self.upcomingInvitations.removeAtIndex(indexPath.row)
            case 1:
                var requestGroup = self.requests[indexPath.row]
                for request in requestGroup {
                    request.denyRequest()
                }
                self.requests.removeAtIndex(indexPath.row)
            case 2:
                self.notifications.removeAtIndex(indexPath.row)
            default:
                break;
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
        tableView.endUpdates()
    }
    
    func fixRowLine(cell:UITableViewCell) -> UITableViewCell {
        if (cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
            cell.preservesSuperviewLayoutMargins = false
        }
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))){
            cell.separatorInset = UIEdgeInsetsMake(0, 4, 0, 0)
        }
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        return cell
    }

    // MARK: InvitationActionDelegate
    func onAcceptInvitation(invitation:Invitation, sender: InvitationCell) {
        var indexForRow = self.tableView.indexPathForCell(sender)
        if indexForRow == nil {
            return
        }
        
        self.tableView.beginUpdates()
        self.upcomingInvitations.removeAtIndex(indexForRow!.row)
        var indices = [NSIndexPath]()
        indices.append(indexForRow!)
        self.tableView.deleteRowsAtIndexPaths(indices, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
    }
    
    func onRejectInvitation(invitation:Invitation, sender: InvitationCell) {
    }
    
    // MARK: RequestActionDelegate
    func onAcceptRequests(requests: [Request], sender: RequestCell) {
    
        var indexForRow = self.tableView.indexPathForCell(sender)
        if indexForRow == nil {
            return
        }
        
        self.tableView.beginUpdates()
        self.requests.removeAtIndex(indexForRow!.row)
        var indices = [NSIndexPath]()
        indices.append(indexForRow!)
        self.tableView.deleteRowsAtIndexPaths(indices, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
    }
    
    func onDeclineRequests(requests: [Request], sender: RequestCell) {
        // do nothing yet
    }
}

class NotificationCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    var notification : Notification? {
        didSet {
            if let n = notification {
                title.text = "\(n.title) - \(n.message)"
            } else {
                title.text = "Oops, an error occurred"
            }
        }
    }
}
