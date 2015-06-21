//
//  EventDetailViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class EventDetailViewController : ZoomableCollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var invitation : Invitation?
    
    @IBOutlet weak var headerImage: PFImageView!
    var photos : [Photo] = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = invitation?.event.title

        self.headerImage.file = invitation?.event.coverPhoto
        self.headerImage.loadInBackground()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Scale up to maximum
        flowLayout.itemSize = aspectScaleWithConstraints(flowLayout.itemSize, scale: 10, max: maxSize, min: minSize)
        self.refreshControl.beginRefreshing()
        self.refreshData()
    }
    
    func refreshData() {
        self.invitation?.event.getAllPhotosInEvent(kOrderedByNewestFirst) {photos in
            self.photos = photos
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


// UICollectionViewDataSource Extension
extension EventDetailViewController {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! SelectableImageCell
        cell.image.file = self.photos[indexPath.row].thumbnailFile
        cell.image.loadInBackground()
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.updateCheckState()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
}