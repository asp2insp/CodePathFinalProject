//
//  NotificationsViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/20/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class NotificationsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, InvitationActionDelegate, RequestActionDelegate {
    @IBAction func onLogOut(sender: UIBarButtonItem) {
        var notification = NSNotification(name: kUserDidLogOutNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    @IBOutlet weak var tableView: UITableView!
    var notifications : [Notification] = []
    var upcomingInvitations : [Invitation] = []
    var requests : [Request] = []
    
    var refreshControl : UIRefreshControl!
    var refreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 78
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refreshData()
    }
    
    func refreshData() {
        refreshCount += 3
        Notification.getAll() {notifications in
            self.notifications = notifications
            if --self.refreshCount == 0 {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        Invitation.getAllLiveAndFutureNonAcceptedEvents() {invites in
            self.upcomingInvitations = invites
            if --self.refreshCount == 0 {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        Request.getAllPendingRequests() {requests in
            self.requests = requests
            if --self.refreshCount == 0 {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
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
            cell.request = self.requests[indexPath.row]
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
            var deleted : PFObject?
            switch indexPath.section {
            case 0:
                var invitation = self.upcomingInvitations[indexPath.row]
                invitation.deleteInBackground()
                deleted = self.upcomingInvitations.removeAtIndex(indexPath.row)
            case 1:
                var request = self.requests[indexPath.row]
                request.denyRequest()
                deleted = self.requests.removeAtIndex(indexPath.row)
            case 2:
                deleted = self.notifications.removeAtIndex(indexPath.row)
            default:
                deleted = nil
            }
            deleted?.deleteInBackground()
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
    func onAcceptRequest(request:Request, sender: RequestCell) {
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
    
    func onDeclineRequest(request:Request, sender: RequestCell) {
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
