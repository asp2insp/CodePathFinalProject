//
//  EventDetailViewController.swift
//  Pretto
//
//  Created by Josiah Gaskin on 6/14/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import Foundation

class EventDetailViewController : ZoomableCollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = event?.title
    }
}


// UICollectionViewDataSource Extension
extension EventDetailViewController {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! SelectableImageCell
        cell.backgroundColor = UIColor.blueColor()
        cell.updateCheckState()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.event?.getAllPhotosInEvent(nil).count ?? 0
    }
}