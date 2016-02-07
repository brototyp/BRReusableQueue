//
//  ReusableViewController.swift
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 30.01.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

import UIKit

class ReusableViewController: UIViewController, BRReusable {
    
    func prepareForReuse() {
        self.view.backgroundColor = randomColor()
    }
    
    static func newForReuse() -> AnyObject? {
        return ReusableViewController()
    }
    
    func randomColor() -> UIColor {
        let hue = CGFloat( Double(arc4random() % 256) / 256.0 );
        let saturation = CGFloat( Double(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness = CGFloat( Double(arc4random() % 128) / 256.0 ) + 0.5;
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            BRReusableQueue.sharedQueue.enqueueReusable(self)
        }
    }
    
}