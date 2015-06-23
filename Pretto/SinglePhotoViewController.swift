//
//  SinglePhotoViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/23/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit
import CoreImage

class SinglePhotoViewController: UIViewController {
    
    @IBAction func onDone(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var photoView: PFImageView!
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var photos: [Photo]!
    var index: Int!
    
    // For Face Recognition
    private var context: CIContext!
    private var detector: CIDetector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.contentMode = UIViewContentMode.ScaleAspectFit
        photoView.userInteractionEnabled = true
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        photoView.addGestureRecognizer(leftSwipe)
        photoView.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view.
        
        activityIndicator.center = self.view.center
        
        loadImageToDisplay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImageToDisplay() {
        addActivityIndicator()
        let localPath = self.photos![index!].localPath
        let fullSizeImage = UIImage(contentsOfFile: localPath)
        photoView.file = self.photos![index!].fullsizeFile ?? self.photos![index!].thumbnailFile
        photoView.loadInBackground { (image: UIImage?, error:NSError?) -> Void in
            self.removeActivityIndicator()
            if let fullSizeImage = fullSizeImage {
                if let ciImage = fullSizeImage.CIImage {
                    var features: [CIFeature] = self.detectFacesOnImage(image!.CIImage)!
                    if features.count > 0 {
                        for feature in features {
                            println(feature.bounds)
                            println(feature.type)
                        }
                    }
                }
            }

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
    func swipeLeft() {
        if index! < photos.count - 1 {
            index!++
            loadImageToDisplay()
        }
    }
    
    func swipeRight() {
        if index! > 0 {
            index!--
            loadImageToDisplay()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: FaceRegonition
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
