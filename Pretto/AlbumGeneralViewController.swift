//
//  AlbumGeneralViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

let albumGeneralCellReuseIdentifier = "AlbumGeneralViewCell"
let futureAlbumReuseIdentifier = "FutureEventCell"
let noAlbumsCellReuseIdentifier = "NoAlbumsCell"

class AlbumGeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var segmentedControlContainerView: UIView!
    
    private var refreshControl : UIRefreshControl!
    private var liveInvitations : [Invitation] = []
    private var pastInvitations : [Invitation] = []
    private var futureInvitations : [Invitation] = []
    private var selectedInvitation : Invitation?
    private var searchBar: UISearchBar!
    private var shouldPresentFutureEvents: Bool!
    
    private var photoPicker: UIImagePickerController!
    var observer : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPresentFutureEvents = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tappedOnCamera", name: kUserDidPressCameraNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createEvent", name: kDidPressCreateEventNotification, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.prettoLightGrey()
        tableView.separatorColor = UIColor.clearColor()
        tableView.registerNib(UINib(nibName: "NoAlbumsCell", bundle: nil), forCellReuseIdentifier: noAlbumsCellReuseIdentifier)
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.navigationItem.titleView = searchBar
        
        for firstLevelSubView in searchBar.subviews {
            for secondLevelSubView in firstLevelSubView.subviews! {
                if secondLevelSubView.isKindOfClass(UITextField) {
                    var searchText: UITextField = secondLevelSubView as! UITextField
                    searchText.textColor = UIColor.whiteColor()
                }
            }
        }
        
        segmentedControl.tintColor = UIColor.clearColor()
        segmentedControl.backgroundColor = UIColor.prettoBlue()
        segmentedControlContainerView.backgroundColor = UIColor.prettoBlue()
        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor(), NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleThick.rawValue], forState: UIControlState.Selected)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControlValueChanged(segmentedControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraView.hidden = false
        shouldPresentFutureEvents = false
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
    
    deinit {
        println("AlbumGeneralViewController : deinit")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserDidPressCameraNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kDidPressCreateEventNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kNewPhotoForEventNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        if shouldPresentFutureEvents! {
            Invitation.getAllLiveAndFutureNonAcceptedEvents { (invites) -> Void in
                self.futureInvitations = invites
            }
        } else {
            
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
        }
        self.refreshControl.endRefreshing()
    }
    
    func createEvent() {
        self.performSegueWithIdentifier("CreateEventSegue", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AlbumDetailSegue" {
            let destination = segue.destinationViewController as! EventDetailViewController
            destination.invitation = self.selectedInvitation
            self.selectedInvitation = nil
        } else if segue.identifier == "EditEventSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            navController.navigationBar.topItem?.title = "EDIT"
            let destination = navController.topViewController as! CreateEventViewController
            var eventInvite: Invitation = selectedInvitation!
            var eventToEdit: Event = eventInvite.event
            destination.startDate = eventToEdit.startDate
            destination.endDate = eventToEdit.endDate
            destination.eventPhoto = UIImage(data: eventToEdit.coverPhoto!.getData()!) ?? nil
            destination.eventTitle = eventToEdit.title
        }
    }

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
    
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
//            segmentedControl.setTitle("> Live & Past", forSegmentAtIndex: 0)
//            segmentedControl.setTitle("Upcoming", forSegmentAtIndex: 1)
            shouldPresentFutureEvents = false
            tableView.separatorColor = UIColor.clearColor()
        } else {
//            segmentedControl.setTitle("Live & Past", forSegmentAtIndex: 0)
//            segmentedControl.setTitle("> Upcoming", forSegmentAtIndex: 1)
            shouldPresentFutureEvents = true
            tableView.separatorColor = UIColor.prettoBlue()
        }
        tableView.reloadData()
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
        if shouldPresentFutureEvents! {
            if futureInvitations.count > 0 {
                return 60
            } else {
                return 0
            }
        } else {
            if liveInvitations.count > 0 || pastInvitations.count > 0 {
                return 218
            } else {
                return 420
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.resignFirstResponder()
        if shouldPresentFutureEvents! {
            if futureInvitations.count > 0 {
                self.selectedInvitation = futureInvitations[indexPath.row]
            }
            self.performSegueWithIdentifier("EditEventSegue", sender: self)
        } else {
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
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel.textColor = UIColor.prettoBlue()
    }
    
}

// MARK: UITableViewDataSource

extension AlbumGeneralViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if shouldPresentFutureEvents! {
            return 1
        } else {
            if liveInvitations.count > 0 || pastInvitations.count > 0 {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldPresentFutureEvents! {
            return futureInvitations.count
        } else {
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
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if shouldPresentFutureEvents! {
            return "Upcoming Events"
        } else {
            switch section {
            case 0:
                return liveInvitations.count > 0 ? "Live Events" : nil
            case 1:
                return pastInvitations.count > 0 ? "Past Events" : nil
            default:
                return nil
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if shouldPresentFutureEvents! {
            var headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
            headerView.contentView.backgroundColor = UIColor.prettoLightGrey()
            return headerView
        } else {
            var headerView = UITableViewHeaderFooterView(frame: CGRectZero)
            headerView.contentView.backgroundColor = UIColor.prettoLightGrey()
            return headerView
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if shouldPresentFutureEvents! {
            if futureInvitations.count > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(futureAlbumReuseIdentifier, forIndexPath: indexPath) as! FutureEventCell
                cell.event = futureInvitations[indexPath.row].event
                return cell
            } else {
                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
        } else {
            if liveInvitations.count > 0 || pastInvitations.count > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(albumGeneralCellReuseIdentifier, forIndexPath: indexPath) as! AlbumGeneralViewCell
                switch indexPath.section {
                case 0:
//                    cell.event = liveInvitations[indexPath.row].event
                    cell.invite = liveInvitations[indexPath.row]
                case 1:
//                    cell.event = pastInvitations[indexPath.row].event
                    cell.invite = pastInvitations[indexPath.row]
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
}


