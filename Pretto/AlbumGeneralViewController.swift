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
    @IBOutlet weak var segmentedControlUnderlineView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    private var refreshControl : UIRefreshControl!
    private var liveInvitations : [Invitation] = []
    private var pastInvitations : [Invitation] = []
    private var futureInvitations : [Invitation] = []
    private var selectedInvitation : Invitation?
    private var searchBar: UISearchBar!
    private var shouldPresentFutureEvents: Bool!
    
    private let emptyBackgroundView = UIView(frame: UIScreen.mainScreen().bounds)
    private let emptyNotificationsView = UIImageView(image: UIImage(named: "UpcomingEmptyCircle"))
    
    private var photoPicker: UIImagePickerController!
    var observer : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.prettoLightGrey()
        cameraView.hidden = true
        shouldPresentFutureEvents = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tappedOnCamera", name: kUserDidPressCameraNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createEvent", name: kDidPressCreateEventNotification, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.prettoLightGrey()
        tableView.separatorColor = UIColor.clearColor()
        tableView.registerNib(UINib(nibName: "NoAlbumsCell", bundle: nil), forCellReuseIdentifier: noAlbumsCellReuseIdentifier)
        
        
        emptyNotificationsView.frame = CGRect(x: 0, y: 0, width: 240, height: 240)
        emptyBackgroundView.addSubview(emptyNotificationsView)
        emptyBackgroundView.bringSubviewToFront(emptyNotificationsView)
        emptyNotificationsView.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: UIScreen.mainScreen().bounds.height / 2 - 90)
        tableView.backgroundView = emptyBackgroundView
        emptyNotificationsView.hidden = true
        
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
        
        separatorView.backgroundColor = UIColor.prettoLightGrey()
        segmentedControl.tintColor = UIColor.clearColor()
        segmentedControl.backgroundColor = UIColor.clearColor()
        segmentedControlContainerView.backgroundColor = UIColor.prettoLightGrey()
        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.prettoBlue()], forState: UIControlState.Normal)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.prettoOrange()], forState: UIControlState.Selected)

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
        shouldPresentFutureEvents = false
        photoPicker = UIImagePickerController()
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(kNewPhotoForEventNotification, object: nil, queue: nil) { (note) -> Void in
           self.refreshData()
        }
        self.refreshData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
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
            Invitation.getAllFutureEvents { (invites) -> Void in
                self.futureInvitations = invites
                if self.futureInvitations.count > 0 {
                    self.emptyNotificationsView.hidden = true
                } else {
                    self.emptyNotificationsView.hidden = false
                }
                self.tableView.reloadData()
            }
        } else {
            Invitation.getAllPastEvents() { (invites) -> Void in
                self.pastInvitations = invites
                self.tableView.reloadData()
            }
            
            Invitation.getAllLiveEvents() { (invites) -> Void in
                self.liveInvitations = invites
                if self.liveInvitations.count > 0 {
                    cameraView.hidden = false
                    for invite in self.liveInvitations {
                        invite.pinInBackground()
                        invite.updateFromCameraRoll()
                    }
                    self.tableView.reloadData()
                    for cell in self.tableView.visibleCells() {
                        (cell as! AlbumGeneralViewCell).updateData()
                    }
                } else {
                    cameraView.hidden = true
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
            destination.eventPhoto = eventToEdit.coverPhoto != nil ? UIImage(data: eventToEdit.coverPhoto!.getData()!) : nil
            destination.eventTitle = eventToEdit.title
        } else if segue.identifier == "CreateEventSegue" {
            cameraView.hidden = true
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
        searchBar.resignFirstResponder()
        if segmentedControl.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.segmentedControlUnderlineView.frame.origin.x = 0
            })
            shouldPresentFutureEvents = false
            tableView.separatorColor = UIColor.clearColor()
            self.emptyNotificationsView.hidden = true
            tableView.reloadData()
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.segmentedControlUnderlineView.frame.origin.x = self.view.center.x
            })
            shouldPresentFutureEvents = true
            tableView.separatorColor = futureInvitations.count > 0 ?  UIColor.prettoBlue() : UIColor.clearColor()
            
            self.refreshData()
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if shouldPresentFutureEvents! {
            return 0
        } else {
            return 30
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        headerView.contentView.backgroundColor = UIColor.prettoLightGrey()
        let headerTitle = UILabel(frame: CGRect(x: headerView.frame.origin.x +  12, y: headerView.frame.origin.y, width: headerView.frame.width - 16, height: headerView.frame.height))
        headerTitle.backgroundColor = UIColor.clearColor()
        headerTitle.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        headerTitle.textColor = UIColor.prettoBlue()
        headerView.addSubview(headerTitle)
        headerView.bringSubviewToFront(headerTitle)
        
        if shouldPresentFutureEvents! {
            return nil
//            headerView = UITableViewHeaderFooterView(frame: CGRectZero)
//            headerView.contentView.backgroundColor = UIColor.prettoLightGrey()
        } else {
            switch section {
            case 0:
                if liveInvitations.count > 0 {
                    headerTitle.text = "Live Events"
                } else {
                    return nil
                }
            case 1:
                if pastInvitations.count > 0 {
                    headerTitle.text = "Past Events"
                } else {
                    return nil
                }
            default:
                return nil
            }
        }
        return headerView
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


