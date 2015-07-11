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
    
    private let numberOfPages: CGFloat = 4
    
    private var firstScreen: FirstIntroView!
    private var secondScreen: SecondIntroView!
    private var thirdScreen: ThirdIntroView!
    private var fourthScreen: TransitionScreen!
    
    private var runFirstAnimation: Bool!
    private var runSecondAnimation: Bool!
    private var runThirdAnimation: Bool!
    
    private let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    private let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var awesomeButton: UIButton!

    
    @IBAction func onSkip(sender: UIButton) {
        println("onSkip")
        var notification = NSNotification(name: kIntroDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        println("IntroViewController : viewDidLoad")
        super.viewDidLoad()
        //scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.contentSize = CGSize(width: screenWidth * numberOfPages, height: screenHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        
        firstScreen = FirstIntroView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        firstScreen.backgroundColor = UIColor.prettoIntroBlue()
//        firstScreen.mainView.backgroundColor = UIColor.prettoLightGrey()
        secondScreen = SecondIntroView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
        secondScreen.backgroundColor = UIColor.prettoIntroBlue()
//        secondScreen.mainView.backgroundColor = UIColor.prettoLightGrey()
        thirdScreen = ThirdIntroView(frame: CGRect(x: screenWidth * 2, y: 0, width: screenWidth, height: screenHeight))
        thirdScreen.backgroundColor = UIColor.prettoIntroBlue()
//        thirdScreen.mainView.backgroundColor = UIColor.prettoLightGrey()
        
        let transitionView = TransitionScreen(frame: CGRect(x: screenWidth * 3, y: 0, width: screenWidth, height: screenHeight))
        fourthScreen = transitionView
        
        self.scrollView.addSubview(firstScreen)
        self.scrollView.addSubview(secondScreen)
        self.scrollView.addSubview(thirdScreen)
        self.scrollView.addSubview(fourthScreen)
        
        runFirstAnimation = true
        runSecondAnimation = true
        runThirdAnimation = true
        
        pageControl.numberOfPages = Int(numberOfPages)
        pageControl.currentPage = 0
        
        awesomeButton.hidden = true
        skipButton.hidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        if pageControl.currentPage == 3 {
            skipButton.hidden = true
            awesomeButton.hidden = true
            pageControl.hidden = true
            var logoHeight = CGFloat(98.0)
            var logoWidth = CGFloat(168.0)
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.fourthScreen.logoImage.frame = CGRect(x: (self.view.frame.width - logoWidth) / 2.0, y: 50.0, width: logoWidth, height: logoHeight)
                self.fourthScreen.thingyView.center = self.view.center
                }, completion: { (success:Bool) -> Void in
                var notification = NSNotification(name: kIntroDidFinishNotification, object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
            
        }
        
        if pageControl.currentPage == 2 {
            skipButton.hidden = true
            awesomeButton.hidden = false
        } else {
            skipButton.hidden = false
            awesomeButton.hidden = true
        }
        
        // Reset animations when scrolling
        switch pageControl.currentPage {
        case 0:
            if runFirstAnimation! {
                self.firstScreen.animationTrigger()
            }
            runFirstAnimation = false
            runSecondAnimation = true
            
        case 1:
            if runSecondAnimation! {
                self.secondScreen.animationTrigger()
            }
            runFirstAnimation = true
            runSecondAnimation = false
            runThirdAnimation = true
        case 2:
            if runThirdAnimation! {
                self.thirdScreen.animationTrigger()
            }
            runSecondAnimation = true
            runThirdAnimation = false
        default:
            break
        }
    }
    
}