//
//  ViewController.swift
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 30.01.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {

    let pageViewController = UIPageViewController.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        pageViewController.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let firstViewController = ReusableViewController()
        pageViewController.setViewControllers([firstViewController], direction: .Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = ReusableQueue.sharedQueue.dequeueOrCreateReusableWithClass(ReusableViewController) as? ReusableViewController {
            return viewController
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewController = ReusableQueue.sharedQueue.dequeueOrCreateReusableWithClass(ReusableViewController) as? ReusableViewController {
            return viewController
        }
        return nil
    }
    
}

