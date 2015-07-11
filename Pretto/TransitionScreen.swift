//
//  TransitionScreen.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/9/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class TransitionScreen: UIView {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var thingyView: UIImageView!
    @IBOutlet var copyRightLabel: UILabel!
    
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
        NSBundle.mainBundle().loadNibNamed("TransitionScreen", owner: self, options: nil)
        
        // 2. Some setup
        self.mainView.frame = UIScreen.mainScreen().bounds
        self.mainView.backgroundColor = UIColor.prettoBlue()
        
        // 3. Add as a subview
        self.addSubview(self.mainView)
    }
    
    func startAnimation(completion: (success: Bool) -> Void) {
        addAnimations { (success) -> Void in
            completion(success: success)
        }
    }
    
    private func addAnimations(completion: (success: Bool) -> Void) {
        println("Adding Animations")

        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.logoImage.center.x -= 500
                self.thingyView.center.x += 500
                self.copyRightLabel.center.y += 100
            }) { (success:Bool) -> Void in
                completion(success: success)
        }
    }
}
