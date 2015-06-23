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
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var headerImage: PFImageView!
    var photos : [Photo] = []
    var refreshControl : UIRefreshControl!
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestButton.backgroundColor = UIColor.prettoBlue()
        
        self.title = invitation?.event.title

        self.headerImage.file = invitation?.event.coverPhoto
        self.headerImage.loadInBackground()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        self.onSelectionChange()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraView.hidden = false
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
    
    
    @IBAction func didTapRequestPhotos(sender: UIButton) {
        requestButton.setTitle("Requesting photos...", forState: UIControlState.Normal)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            for path in self.selectedPaths {
                Request.makeRequestForPhoto(self.photos[path.row]).save()
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.requestButton.setTitle("Request Sent!", forState: UIControlState.Normal)
            }
        }
    }
    
    override func onSelectionChange() {
        let selectionCount = selectedPaths.count
        if selectionCount == 0 {
            requestButton.setTitle("Select Photos", forState: UIControlState.Normal)
            requestButton.enabled = false
        } else {
            requestButton.setTitle("Request \(selectionCount) Photos", forState: UIControlState.Normal)
            requestButton.enabled = true
        }
    }
}

// MARK: AUX Methods
extension EventDetailViewController {
    func doubleTapReconized(sender: UITapGestureRecognizer) {
        println(collectionView.indexPathForCell(sender.view as! SelectableImageCell))
        selectedIndex = collectionView.indexPathForCell(sender.view as! SelectableImageCell)?.row
        self.performSegueWithIdentifier("SingleImageViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Preparing for Segue")
        cameraView.hidden = true
        let singlePhotoVC = segue.destinationViewController as! SinglePhotoViewController
        singlePhotoVC.photos = self.photos
        singlePhotoVC.index = self.selectedIndex ?? 0
        
    }
}

// UICollectionViewDataSource Extension
extension EventDetailViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! SelectableImageCell
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapReconized:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapRecognizer)
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