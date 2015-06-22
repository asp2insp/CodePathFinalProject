//
//  FirstIntroView.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/22/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class FirstIntroView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet var palmImage: UIImageView!
    @IBOutlet var weddingImage: UIImageView!
    @IBOutlet var graduationImage: UIImageView!
    @IBOutlet var partyImage: UIImageView!
    
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
        NSBundle.mainBundle().loadNibNamed("FirstIntroView", owner: self, options: nil)
        
        // 2. Some setup
        self.mainView.frame = self.bounds
        self.mainView.backgroundColor = UIColor.prettoIntroOrange()
        self.palmImage.hidden = true
        self.weddingImage.hidden = true
        self.graduationImage.hidden = true
        self.partyImage.hidden = true
        
        self.addAnimations()
        
        // 3. Add as a subview
        self.addSubview(self.mainView)
    }
    
    func animationTrigger() {
        self.addAnimations()
    }
    
    private func addAnimations() {
        
        self.palmImage.transform = CGAffineTransformMakeScale(0, 0)
        self.weddingImage.transform = CGAffineTransformMakeScale(0, 0)
        self.graduationImage.transform = CGAffineTransformMakeScale(0, 0)
        self.partyImage.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
            self.weddingImage.hidden = false
            self.weddingImage.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: {
            self.palmImage.hidden = false
            self.palmImage.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: {
            self.partyImage.hidden = false
            self.partyImage.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
        
        
        UIView.animateWithDuration(0.5, delay: 0.9, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: nil, animations: {
            self.graduationImage.hidden = false
            self.graduationImage.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
    }
}
