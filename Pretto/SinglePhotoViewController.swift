//
//  SinglePhotoViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/23/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreImage

class SinglePhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBAction func onDone(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var photos: [Photo]!
    
    // For Face Recognition
    private var context: CIContext!
    private var detector: CIDetector!
    
    var initialIndex : Int = 0
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        let pageCount = photos.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
    }
    
    var onceToken : dispatch_once_t = 0
    override func viewDidLayoutSubviews() {
        dispatch_once(&onceToken) {
            let pagesScrollViewSize = self.scrollView.frame.size
            self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(self.photos.count), pagesScrollViewSize.height)
            
            let initialOffset = CGPointMake(CGFloat(self.initialIndex) * pagesScrollViewSize.width, 0)
            self.scrollView.setContentOffset(initialOffset, animated: false)
            self.loadVisiblePages()
        }
    }
    
    func addActivityIndicator() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= photos.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }

        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            addActivityIndicator()
            let newPageView = PFImageView()
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
            
            newPageView.file = self.photos![page].fullsizeFile ?? self.photos![page].thumbnailFile
            newPageView.loadInBackground { (image: UIImage?, error:NSError?) -> Void in
                self.removeActivityIndicator()
            }
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= photos.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < photos.count; ++index {
            purgePage(index)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
}

// TODO add in facial recognition on image load:
//    func loadImageToDisplay() {
//        addActivityIndicator()
//        let localPath = self.photos![index!].localPath
//        let fullSizeImage = UIImage(contentsOfFile: localPath)
//        photoView.file = self.photos![index!].fullsizeFile ?? self.photos![index!].thumbnailFile
//        photoView.loadInBackground { (image: UIImage?, error:NSError?) -> Void in
//            self.removeActivityIndicator()
//            if let fullSizeImage = fullSizeImage {
//                if let ciImage = fullSizeImage.CIImage {
//                    var features: [CIFeature] = self.detectFacesOnImage(image!.CIImage)!
//                    if features.count > 0 {
//                        for feature in features {
//                            println(feature.bounds)
//                            println(feature.type)
//                        }
//                    }
//                }
//            }
//
//        }
//    }

//MARK: FaceRecognition
extension SinglePhotoViewController {
    func initializeFaceDetector() {
        context = CIContext(options: nil)
        var opts: NSDictionary = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: opts as [NSObject:AnyObject])
    }
    
    func detectFacesOnImage(image: CIImage!) -> [CIFeature]? {
        return detector.featuresInImage(image) as? [CIFeature]
    }
}
