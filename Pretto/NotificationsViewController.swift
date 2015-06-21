//
//  NotificationsViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/20/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class NotificationsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var notifications : [Notification] = []
    var upcomingInvitations : [Invitation] = []
    var requests : [Request] = []
    
    var refreshControl : UIRefreshControl!
    var refreshCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        Invitation.getAllFutureEvents() {invites in
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Invitations"
        case 1:
            return "Requests"
        case 2:
            return "Notifications"
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
            let cell = tableView.dequeueReusableCellWithIdentifier("invitecell", forIndexPath: indexPath) as! InviteCell
            cell.invite = self.upcomingInvitations[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("requestcell", forIndexPath: indexPath) as! RequestCell
            cell.request = self.requests[indexPath.row]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("notificationcell", forIndexPath: indexPath) as! NotificationCell
            cell.notification = self.notifications[indexPath.row]
            return cell
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
                deleted = self.upcomingInvitations.removeAtIndex(indexPath.row)
            case 1:
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
}

class RequestCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    var request : Request? {
        didSet {
            if let request = self.request {
                let requester = User(innerUser: request.requester)
                let name = requester.firstName ?? "Someone"
                title.text = "\(name) has requested a photo from you!"
            } else {
                title.text = "Oops, an error occurred"
            }
        }
    }
}

class InviteCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    var invite : Invitation? {
        didSet {
            if let invite = self.invite {
                let host = User(innerUser: invite.from)
                let name = host.firstName ?? "Someone"
                title.text = "\(name) has invited you to their event \(invite.event.title)"
            } else {
                title.text = "Oops, an error occurred"
            }
        }
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
