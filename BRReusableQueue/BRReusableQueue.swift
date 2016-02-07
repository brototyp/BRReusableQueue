//
//  BRReusableQueue.swift
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 30.01.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol BRReusable: class {
    optional static func reuseIdentifier() -> String // if not implemented, classname is used
    optional static func newForReuse() -> AnyObject? // if implemented, dequeueOrCreateReusableWithClass can be used
    optional func prepareForReuse() -> Void
}

@objc public class BRReusableQueue : NSObject {
    var reusables: NSCache = NSCache()
    public var emptyOnMemoryWarningNotification = true
    
    public static let sharedQueue = BRReusableQueue()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override init () {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didReceiveMemoryWarning",
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: nil)
    }
    
    public func enqueueReusable(reusable: BRReusable) -> Void {
        let identifier = identifierFromReusableClass(reusable.dynamicType)
        var objects: Array<BRReusable> = reusables.objectForKey(identifier) as? Array<BRReusable> ??  Array<BRReusable>()
        reusable.prepareForReuse?()
        objects.append(reusable)
        reusables.setObject(objects, forKey: identifier)
    }
    
    public func dequeueReusableWithIdentifier(identifier: String) -> BRReusable? {
        if var objects: Array<BRReusable> = reusables.objectForKey(identifier) as? Array<BRReusable> where
            objects.count > 0 {
            let reusable = objects.removeFirst()
            reusables.setObject(objects, forKey: identifier)
            return reusable
        }
        return nil
    }
    
    public func dequeueReusableWithClass(reusableClass: BRReusable.Type) -> BRReusable? {
        return dequeueReusableWithIdentifier(identifierFromReusableClass(reusableClass))
    }
    
    public func dequeueOrCreateReusableWithClass(reusableClass: BRReusable.Type) -> BRReusable? {
        if let reusable = dequeueReusableWithClass(reusableClass) {
            return reusable
        }
        let createdReusable = reusableClass.newForReuse?()
        if let reusable = createdReusable as? BRReusable {
            return reusable
        }
        return nil
    }
    
    public func emptyQueue() -> Void {
        reusables.removeAllObjects()
    }
    
    func didReceiveMemoryWarning() -> Void {
        if !emptyOnMemoryWarningNotification {
            return
        }
        emptyQueue()
    }
    
    private func identifierFromReusableClass(reusable: BRReusable.Type) -> String {
        if let identifier = reusable.reuseIdentifier?() {
            return identifier
        }
        return  "\(reusable)"
    }
    
}