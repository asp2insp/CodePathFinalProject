//
//  SecondIntroView.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class SecondIntroView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var flash1: UIImageView!
    @IBOutlet var flash2: UIImageView!
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
        NSBundle.mainBundle().loadNibNamed("SecondIntroView", owner: self, options: nil)
        
        // 2. Some setup
        self.mainView.frame = self.bounds
        self.mainView.backgroundColor = UIColor.prettoIntroBlue()
        
        self.addAnimations()
        
        // 3. Add as a subview
        self.addSubview(self.mainView)
    }
    
    func animationTrigger() {
        self.addAnimations()
    }
    
    private func addAnimations(){
        UIView.animateWithDuration(0.2, delay: 0.3, options: .Autoreverse | .CurveEaseIn, animations: {
            self.flash1.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }, completion: { finished in
                self.flash1.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
        UIView.animateWithDuration(0.2, delay: 0.4, options: .Autoreverse | .CurveEaseIn, animations: {
            self.flash2.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }, completion: { finished in
                self.flash2.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
}
