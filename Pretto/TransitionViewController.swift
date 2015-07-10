//
//  TransitionViewController.swift
//  Pretto
//
//  Created by Francisco de la Pena on 7/9/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {
    
    private var transitionView: TransitionScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitionView = TransitionScreen(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.width))
        self.view.addSubview(transitionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAnimation(completion: (success: Bool) -> Void) {
        println("TransitionViewController : startAnimation")
        transitionView.startAnimation { (success) -> Void in
            completion(success: success)
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
