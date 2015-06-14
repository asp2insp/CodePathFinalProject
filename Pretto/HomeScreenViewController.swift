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
        refreshData()
    }
    
    func refreshData() {
        Event.getAllLiveEvents() { (events) -> Void in
            self.liveEvents = events
            self.collectionView.reloadData()
        }
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
        return liveEvents[section].getAllPhotosInEvent(nil).count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return liveEvents.count
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