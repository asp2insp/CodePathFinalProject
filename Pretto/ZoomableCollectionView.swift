//
//  ZoomableCollectionViewController.swift
//  ZoomableCollectionsView
//
//  Created by Josiah Gaskin on 6/1/15.
//  Copyright (c) 2015 asp2insp. All rights reserved.
//

import UIKit

class ZoomableCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    var baseSize : CGSize!
    var maxSize : CGSize!
    let minSize = CGSizeMake(30.0, 30.0)
    
    // Long press handling
    var selectionStart : NSIndexPath!
    var previousRange : [NSIndexPath]?
    var previousIndex : NSIndexPath?
    
    // Set to enable/disable selection and checkboxes
    var allowsSelection : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.allowsMultipleSelection = true
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        maxSize = view.bounds.size
    }
    
    @IBAction func didPinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .Began:
            baseSize = flowLayout.itemSize
        case .Changed:
            flowLayout.itemSize = aspectScaleWithConstraints(baseSize, scale: sender.scale, max: maxSize, min: minSize)
        case .Ended, .Cancelled:
            flowLayout.itemSize = aspectScaleWithConstraints(baseSize, scale: sender.scale, max: maxSize, min: minSize)
        default:
            return
        }
    }
    
    func aspectScaleWithConstraints(size: CGSize, scale: CGFloat, max: CGSize, min: CGSize) -> CGSize {
        let maxHScale = fmax(max.width / size.width, 1.0)
        let maxVScale = fmax(max.height / size.height, 1.0)
        let scaleBoundedByMax = fmin(fmin(scale, maxHScale), maxVScale)
        let minHScale = fmin(min.width / size.width, 1.0)
        let minVScale = fmin(min.height / size.height, 1.0)
        let scaleBoundedByMin = fmax(fmax(scaleBoundedByMax, minHScale), minVScale)
        return CGSizeMake(size.width * scaleBoundedByMin, size.height * scaleBoundedByMin)
    }
    
    @IBAction func didLongPressAndDrag(sender: UILongPressGestureRecognizer) {
        let touchCoords = sender.locationInView(collectionView)
        switch sender.state {
        case .Began, .Changed:
            let currentIndex = pointToIndexPath(touchCoords, fuzzySize: 5)
            if currentIndex != nil {
                if selectionStart == nil {
                    selectionStart = currentIndex
                    selectItemAtIndexPathIfNecessary(selectionStart)
                    return
                }
                // Change detection
                if currentIndex != previousIndex {
                    let itemsToSelect = getIndexRange(start: selectionStart, end: currentIndex!)
                    let itemsToDeselect = difference(previousRange, minus: itemsToSelect)
                    for path in itemsToDeselect {
                        deselectItemAtIndexPathIfNecessary(path)
                    }
                    for path in itemsToSelect {
                        selectItemAtIndexPathIfNecessary(path)
                    }
                    previousRange = itemsToSelect
                    previousIndex = currentIndex
                }
            }
        case .Cancelled, .Ended:
            selectionStart = nil
            previousRange = nil
            previousIndex = nil
        default:
            return
        }
    }
    
    func selectItemAtIndexPathIfNecessary(path: NSIndexPath) {
        if !allowsSelection {
            return
        }
        if let cell = collectionView.cellForItemAtIndexPath(path) as? SelectableImageCell {
            if !cell.selected {
                collectionView.selectItemAtIndexPath(path, animated: true, scrollPosition: UICollectionViewScrollPosition.None)
            }
            cell.checkbox.checkState = M13CheckboxStateChecked
            cell.animateStateChange()
        }
    }
    
    func deselectItemAtIndexPathIfNecessary(path: NSIndexPath) {
        if !allowsSelection {
            return
        }
        if let cell = collectionView.cellForItemAtIndexPath(path) as? SelectableImageCell {
            if (cell.selected) {
                collectionView.deselectItemAtIndexPath(path, animated: true)
            }
            cell.checkbox.checkState = M13CheckboxStateUnchecked
            cell.animateStateChange()
        }
    }
    
    // Return the difference of the given arrays of index paths
    func difference(a: [NSIndexPath]?, minus b: [NSIndexPath]?) -> [NSIndexPath] {
        if a == nil {
            return []
        }
        if b == nil {
            return a!
        }
        var final = a!
        for item in b! {
            if let index = find(final, item) {
                final.removeAtIndex(index)
            }
        }
        return final
    }
    
    // Return an array of NSIndexPaths between the given start and end, inclusive
    func getIndexRange(#start: NSIndexPath, end: NSIndexPath) -> [NSIndexPath] {
        var range : [NSIndexPath] = []
        let numItems = abs(start.row - end.row)
        let section = start.section
        for var i = 0; i <= numItems; i++ {
            let newRow = start.row < end.row ? start.row+i : start.row-i
            if newRow >= 0 && newRow < collectionView.numberOfItemsInSection(section) {
                range.append(NSIndexPath(forRow: newRow, inSection: section))
            }
        }
        return range
    }
    
    // Convert a touch point to an index path of the cell under the point.
    // Returns nil if no cell exists under the given point.
    func pointToIndexPath(point: CGPoint, fuzzySize: CGFloat) -> NSIndexPath? {
        let fingerRect = CGRectMake(point.x-fuzzySize, point.y-fuzzySize, fuzzySize*2, fuzzySize*2)
        for item in collectionView.visibleCells() {
            let cell = item as! SelectableImageCell
            if CGRectIntersectsRect(fingerRect, cell.frame) {
                return collectionView.indexPathForCell(cell)
            }
        }
        return nil
    }
}

// UICollectionViewDelegate Extension
extension ZoomableCollectionViewController {
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        deselectItemAtIndexPathIfNecessary(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectItemAtIndexPathIfNecessary(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let c = cell as? SelectableImageCell {
            c.showCheckbox = self.allowsSelection
        }
    }
}

class SelectableImageCell : UICollectionViewCell {
    var image: UIImageView!
    var checkbox: M13Checkbox!
    var showCheckbox : Bool = true {
        didSet {
            self.checkbox.hidden = !showCheckbox
            self.checkbox.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        image = UIImageView(frame: self.bounds)
        checkbox = M13Checkbox(frame: CGRectMake(0, 0, 20, 20))
        checkbox.center = CGPointMake(25, 25)
        checkbox.userInteractionEnabled = false
        checkbox.checkState = selected ? M13CheckboxStateChecked : M13CheckboxStateUnchecked
        checkbox.radius = 0.5 * checkbox.frame.size.width;
        checkbox.flat = true
        checkbox.tintColor = checkbox.strokeColor
        checkbox.checkColor = UIColor.whiteColor()
        
        self.addSubview(image)
        
        self.addSubview(checkbox)
    }
    
    func animateStateChange() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.checkbox.transform = CGAffineTransformMakeScale(2, 2)
            self.checkbox.transform = CGAffineTransformMakeScale(1, 1)
        })
    }
    
    func updateCheckState() {
        checkbox.checkState = selected ? M13CheckboxStateChecked : M13CheckboxStateUnchecked
    }
}