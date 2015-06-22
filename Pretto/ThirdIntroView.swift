//
//  ThirdIntroView.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class ThirdIntroView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var avatar1: UIImageView!
    @IBOutlet var avatar2: UIImageView!
    @IBOutlet var avatar3: UIImageView!
    @IBOutlet var avatar4: UIImageView!
    @IBOutlet var avatar5: UIImageView!
    @IBOutlet var avatar6: UIImageView!
    @IBOutlet var avatar7: UIImageView!
    @IBOutlet var avatar8: UIImageView!
    @IBOutlet var cloudImage: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    
    private func customInit() {
        // 1. Load the interface file from .xib
        NSBundle.mainBundle().loadNibNamed("ThirdIntroView", owner: self, options: nil)
        
        // 2. Some setup
        self.mainView.frame = self.bounds
        self.mainView.backgroundColor = UIColor.prettoIntroGreen()
        
        self.avatar1.alpha = 0.0
        self.avatar2.alpha = 0.0
        self.avatar3.alpha = 0.0
        self.avatar4.alpha = 0.0
        self.avatar5.alpha = 0.0
        self.avatar6.alpha = 0.0
        self.avatar7.alpha = 0.0
        self.avatar8.alpha = 0.0
        
        // 3. Add as a subview
        self.addSubview(self.mainView)
    }
    
    func animationTrigger() {
        self.addAnimations()
    }
    
    private func addAnimations() {
        let avatarArray = [avatar1!, avatar2!, avatar3!, avatar4!, avatar5!, avatar6!, avatar7!, avatar8!]
        var springVelocity = CGFloat(0.7)
        var springDamping = CGFloat(0.7)
        var delay = 0.0
        var scale = CGAffineTransformMakeScale(1.0, 1.0)
        
        while self.mainView.layer.sublayers.count > 11 {
            self.mainView.layer.sublayers[0].removeFromSuperlayer()
        }
        
        for avatar in avatarArray {
            avatar.transform = CGAffineTransformMakeScale(0.0, 0.0)
            let index = find(avatarArray, avatar)

            UIView.animateWithDuration(1.0, delay: delay, usingSpringWithDamping: springVelocity, initialSpringVelocity: springDamping, options: nil, animations: { () -> Void in
                avatar.alpha = 1.0
                avatar.transform = CGAffineTransformMakeScale(1.0, 1.0)

            },  completion: { finished in
                if index == 7 {
                    for avatar in avatarArray {
                        let line = UIBezierPath()
                        line.moveToPoint(avatar.center)
                        line.addLineToPoint(self.cloudImage.center)
                        
                        let progressLine = CAShapeLayer()
                        progressLine.path = line.CGPath
                        progressLine.strokeColor = UIColor.whiteColor().CGColor
                        progressLine.lineWidth = 2.0
                        progressLine.lineDashPattern = [4, 4]
                        self.mainView.layer.insertSublayer(progressLine, atIndex: 0)
                        
                        let animateStroke = CABasicAnimation(keyPath: "strokeEnd")
                        animateStroke.duration = 0.5
                        animateStroke.fromValue = 0.0
                        animateStroke.toValue = 1.0
                        progressLine.addAnimation(animateStroke, forKey: "animate stroke end animation")
                    }
                }
            })
            delay += 0.1
        }
        

    }
}
