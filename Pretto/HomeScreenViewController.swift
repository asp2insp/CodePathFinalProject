//
//  HomeScreenViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class HomeScreenViewController : ZoomableCollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var liveEvents : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0)
        flowLayout.headerReferenceSize = CGSizeMake(0, 100)
        refreshData()
    }
    
    func refreshData() {
        Event.getAllLiveEvents() { (events) -> Void in
            self.liveEvents = events
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        PFUser.logOut()
        (UIApplication.sharedApplication().delegate as! AppDelegate).showLoginWindow()
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
        //return liveEvents[section].getAllPhotosInEvent(nil).count
        return 10
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //return liveEvents.count
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "sectionheader", forIndexPath: indexPath) as! EventHeader
        
        let ev = Event()
        ev.name = "Event \(indexPath.row)"
        header.event = ev
        
        return header
    }
}

// UICollectionViewDelegate Extension
extension HomeScreenViewController {
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        deselectItemAtIndexPathIfNecessary(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectItemAtIndexPathIfNecessary(indexPath)
    }
}

class EventHeader : UICollectionReusableView {
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var event : Event? {
        didSet {
            label.text = event?.name ?? "Unknown"
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
