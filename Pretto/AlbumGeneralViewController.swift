//
//  AlbumGeneralViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let albumGeneralCellReuseIdentifier = "AlbumGeneralViewCell"
let noAlbumsCellReuseIdentifier = "NoAlbumsCell"

class AlbumGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    private var refreshControl : UIRefreshControl!
    private var liveInvitations : [Invitation] = []
    private var selectedInvitation : Invitation?
    private var searchBar: UISearchBar!
    
    var observer : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.prettoLightGrey()
        tableView.separatorColor = UIColor.clearColor()
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.navigationItem.titleView = searchBar
        
        tableView.registerNib(UINib(nibName: "NoAlbumsCell", bundle: nil), forCellReuseIdentifier: noAlbumsCellReuseIdentifier)
        
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
            if self.liveInvitations.count > 0 {
                for invite in self.liveInvitations {
                    invite.pinInBackground()
                    invite.updateFromCameraRoll()
                }
                self.tableView.reloadData()
                for cell in self.tableView.visibleCells() {
                    (cell as! AlbumGeneralViewCell).updateData()
                }
            } else {
                self.tableView.reloadData()
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
        
       if liveInvitations.count != 0 {
            return 218
        } else {
            return 420
        }
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
        return liveInvitations.count > 0 ? liveInvitations.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if liveInvitations.count != 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(albumGeneralCellReuseIdentifier, forIndexPath: indexPath) as! AlbumGeneralViewCell
            cell.event = liveInvitations[indexPath.row].event
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(noAlbumsCellReuseIdentifier, forIndexPath: indexPath) as? NoAlbumsCell
            let originalCenter = cell!.arrow.center
            UIView.animateWithDuration(0.6, delay: 0.0, options: .Autoreverse | .Repeat | .CurveEaseOut, animations: { () -> Void in
                cell!.arrow.center.y = cell!.arrow.center.y - 10
                }, completion: { (success:Bool) -> Void in
                cell!.arrow.center = originalCenter
            })

            return cell!
        }
    }
}
