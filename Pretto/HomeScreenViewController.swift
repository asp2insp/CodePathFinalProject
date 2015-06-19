//
//  HomeScreenViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenViewController : ZoomableCollectionViewController, UICollectionViewDataSource {
    
    var selectedEvent : Event?
    var liveEvents : [Event] = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.headerReferenceSize = CGSizeMake(0, 44)
        flowLayout.footerReferenceSize = CGSizeMake(0, 44)
        allowsSelection = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        refreshData()
    }
    
    func refreshData() {
        Event.getAllLiveEvents() { (events) -> Void in
            self.liveEvents = events
            for event in self.liveEvents {
                event.getInvitation().updateFromCameraRoll()
            }
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOut()
        (UIApplication.sharedApplication().delegate as! AppDelegate).showLandingWindow()
    }
}

// UICollectionViewDataSource Extension
extension HomeScreenViewController {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! SelectableImageCell
        cell.backgroundColor = UIColor.blueColor()
        cell.updateCheckState()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(liveEvents[section].getAllPhotosInEvent(nil).count, 10)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return liveEvents.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let ev = liveEvents[indexPath.section]
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionheader", forIndexPath: indexPath) as! EventHeader
            header.event = ev
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionfooter", forIndexPath: indexPath) as! EventFooter
            footer.event = ev
            return footer
        }
    }
    
    @IBAction func didTapToSelectEvent(sender: AnyObject) {
        let touchCoords = sender.locationInView(collectionView)
        let indexPath = pointToIndexPath(touchCoords, fuzzySize: 10)
        if indexPath != nil {
            self.selectedEvent = liveEvents[indexPath!.section]
            performSegueWithIdentifier("albumdetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "albumdetail" {
            let destination = segue.destinationViewController as! EventDetailViewController
            destination.event = self.selectedEvent
            self.selectedEvent = nil
        }
    }
}

class EventHeader : UICollectionReusableView {
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var event : Event? {
        didSet {
            label.text = event?.title ?? "Unknown"
        }
    }
    
    @IBAction func didTapPause(sender: AnyObject) {
        if pauseButton.currentTitle == "Pause" {
            pauseButton.setTitle("Continue", forState: UIControlState.Normal)
        } else {
            pauseButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
}

class EventFooter : UICollectionReusableView {
    @IBOutlet weak var label: UILabel!
    
    var event : Event? {
        didSet {
            let count = event?.getAllPhotosInEvent(nil).count ?? 0
            label.text = count > 0 ? "+\(count) more" : ""
        }
    }
}
