//
//  IntroViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    private let numberOfPages: CGFloat = 3
    
    private var firstScreen: UIImageView!
    private var secondScreen: UIImageView!
    private var thirdScreen: UIImageView!
    
    private let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    private let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var awesomeButton: UIButton!

    
    @IBAction func onSkip(sender: UIButton) {
        println("onSkip")
        var notification = NSNotification(name: kIntroDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        self.dismissViewControllerAnimated(true, completion: nil)
        
//        var notification = NSNotification(name: kShowLandingWindowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().postNotification(notification)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        println("viewDidLoad")
        super.viewDidLoad()
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSize(width: screenWidth * numberOfPages, height: screenHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        
        firstScreen = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        secondScreen = UIImageView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
        thirdScreen = UIImageView(frame: CGRect(x: screenWidth * 2, y: 0, width: screenWidth, height: screenHeight))
        
        firstScreen.image = UIImage(named: "Intro1")
        secondScreen.image = UIImage(named: "Intro2")
        thirdScreen.image = UIImage(named: "Intro3")
        
        self.scrollView.addSubview(firstScreen)
        self.scrollView.addSubview(secondScreen)
        self.scrollView.addSubview(thirdScreen)
        
        pageControl.numberOfPages = Int(numberOfPages)
        pageControl.currentPage = 0
        
        awesomeButton.hidden = true
        skipButton.hidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: UIScrollView

extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageIndex = floor(scrollView.contentOffset.x / scrollView.frame.width)
//        println("Scrolling Page Index: \(Int(pageIndex))")
        pageControl.currentPage = Int(pageIndex)
        
        if pageControl.currentPage == 2 {
            skipButton.hidden = true
            awesomeButton.hidden = false
        } else {
            skipButton.hidden = false
            awesomeButton.hidden = true
        }
    }
    
}