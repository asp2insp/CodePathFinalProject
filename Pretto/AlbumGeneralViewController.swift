//
//  AlbumGeneralViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class AlbumGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var refreshControl : UIRefreshControl!
    var liveInvitations : [Invitation] = []
    var selectedInvitation : Invitation?
    
    var observer : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.prettoWhite()
        searchBar.backgroundColor = UIColor.prettoWhite()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName("PrettoNewPhotoForEvent", object: nil, queue: nil) { (note) -> Void in
           self.refreshData()
        }
        self.refreshData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        Invitation.getAllLiveEvents() { (invites) -> Void in
            self.liveInvitations = invites
            for invite in self.liveInvitations {
                invite.pinInBackground()
                invite.updateFromCameraRoll()
            }
            self.tableView.reloadData()
            for cell in self.tableView.visibleCells() {
                (cell as! AlbumGeneralViewCell).updateData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOut()
        (UIApplication.sharedApplication().delegate as! AppDelegate).showLandingWindow()
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

extension AlbumGeneralViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var calendarHeight = CGFloat(40.0)
        var calendarTopAndBottom = CGFloat(14.0)
        var cellWidth = tableView.frame.width
        var imageHeight = 0.24 * cellWidth
        var verticalSeparator = CGFloat(5.0)
        var cellHeight = calendarHeight + (2 * imageHeight) + (2 * verticalSeparator) + calendarTopAndBottom
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedInvitation = liveInvitations[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AlbumDetailSegue" {
            let destination = segue.destinationViewController as! EventDetailViewController
            destination.invitation = self.selectedInvitation
            self.selectedInvitation = nil
        }
    }
}

// MARK: UITableViewDataSource

extension AlbumGeneralViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveInvitations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumGeneralViewCell", forIndexPath: indexPath) as! AlbumGeneralViewCell
        cell.event = liveInvitations[indexPath.row].event
        return cell
    }
}
