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

class AlbumGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    private var refreshControl : UIRefreshControl!
    private var liveInvitations : [Invitation] = []
    private var pastInvitations : [Invitation] = []
    private var selectedInvitation : Invitation?
    private var searchBar: UISearchBar!
    
    private var photoPicker: UIImagePickerController!
    var observer : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tappedOnCamera", name: kUserDidPressCameraNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createEvent", name: kDidPressCreateEventNotification, object: nil)
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
        cameraView.hidden = false
        photoPicker = UIImagePickerController()
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(kNewPhotoForEventNotification, object: nil, queue: nil) { (note) -> Void in
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
        Invitation.getAllPastEvents() { (invites) -> Void in
            self.pastInvitations = invites
        }
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
        self.refreshControl.endRefreshing()
    }
    
    func createEvent() {
        self.performSegueWithIdentifier("CreateEventSegue", sender: nil)
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

// MARK: AUX Methods

extension AlbumGeneralViewController {
    func tappedOnCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            photoPicker.delegate = self
            photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
            photoPicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) ? .Rear : .Front
            cameraView.hidden = true
            self.presentViewController(photoPicker, animated: true, completion: nil)
        }
    }

}

// MARK: UIImagePickerControllerDelegate
extension AlbumGeneralViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Photo Taken or Picked")
        cameraView.hidden = false
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UITableViewDelegate

extension AlbumGeneralViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
       if liveInvitations.count > 0 || pastInvitations.count > 0 {
            return 218
        } else {
            return 420
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if liveInvitations.count > 0 || pastInvitations.count > 0 {
            switch indexPath.section {
            case 0:
                self.selectedInvitation = liveInvitations[indexPath.row]
            case 1:
                self.selectedInvitation = pastInvitations[indexPath.row]
            default:
                break
            }
            performSegueWithIdentifier("AlbumDetailSegue", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel.textColor = UIColor.prettoBlue()
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
        if liveInvitations.count > 0 || pastInvitations.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if liveInvitations.count > 0 || pastInvitations.count > 0 {
            switch section {
            case 0:
                return liveInvitations.count
            case 1:
                return pastInvitations.count
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return liveInvitations.count > 0 ? "Live Events" : nil
        case 1:
            return pastInvitations.count > 0 ? "Past Events" : nil
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if liveInvitations.count > 0 || pastInvitations.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AlbumGeneralViewCell", forIndexPath: indexPath) as! AlbumGeneralViewCell
            switch indexPath.section {
            case 0:
                cell.event = liveInvitations[indexPath.row].event
            case 1:
                cell.event = pastInvitations[indexPath.row].event
            default:
                break
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(noAlbumsCellReuseIdentifier, forIndexPath: indexPath) as? NoAlbumsCell
            let originalCenter = cell!.arrow.center
            
            UIView.animateWithDuration(0.6, delay: 0.0, options: .Autoreverse | .Repeat | .CurveEaseOut, animations: { () -> Void in
                cell!.arrow.center.y = cell!.arrow.center.y - 10
                }, completion: { (sucees:Bool) -> Void in
                cell!.arrow.center = originalCenter
            })
            
            return cell!
        }
    }
}


