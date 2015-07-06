//
//  EventCreatedView.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/21/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class EventCreatedView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var eventTItle: UILabel!
    @IBOutlet var eventStartDate: UILabel!
    @IBOutlet var eventEndDate: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet weak var shareOnFacebook: UIButton!
    @IBOutlet weak var shareOnTwitter: UIButton!
    @IBOutlet weak var shareByEmail: UIButton!
    
    @IBAction func onShareOnFacebook(sender: UIButton) {
        println("Share on Facebook")
        var notification = NSNotification(name: kShareOnFacebookNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    @IBAction func onShareOnTwitter(sender: UIButton) {
        println("Share on Twitter")
        var notification = NSNotification(name: kShareOnTwitterNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

    }

    @IBAction func onShareByEmail(sender: UIButton) {
        println("Share by Email")
        var notification = NSNotification(name: kShareByEmailNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)

    }
    
    @IBAction func onOkButton(sender: UIButton) {
        println("Ok")
        var notification = NSNotification(name: kAcceptEventAndDismissVCNotification, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        self.removeFromSuperview()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("EventCreatedView", owner: self, options: nil)
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
//        let cornerRadius = CGFloat(5.0)
//        let bounds = CGRect(x: innerView.bounds.origin.x - 2, y: innerView.bounds.origin.y - 2, width: innerView.bounds.width + 2, height: innerView.bounds.height + 2)
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//        innerView.layer.masksToBounds = false
//        innerView.layer.cornerRadius = cornerRadius
//        innerView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        innerView.layer.borderWidth = 0
//        innerView.layer.shadowColor = UIColor.lightGrayColor().CGColor
//        innerView.layer.shadowOffset = CGSize(width: 4, height: 4)
//        innerView.layer.shadowOpacity = 0.5
//        innerView.layer.shadowPath = shadowPath.CGPath
        
        okButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        okButton.backgroundColor = UIColor.prettoOrange()
        okButton.layer.cornerRadius = 3
        
        shareOnFacebook.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        shareOnFacebook.layer.cornerRadius = 25
        shareOnTwitter.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        shareOnTwitter.layer.cornerRadius = 25
        shareByEmail.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        shareByEmail.layer.cornerRadius = 25

        
        
        self.addSubview(self.mainView)
    }
}
