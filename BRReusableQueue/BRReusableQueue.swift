//
//  BRReusableQueue.swift
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 30.01.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

import Foundation
import UIKit

@objc protocol Reusable: class {
    optional static func reuseIdentifier() -> String // if not implemented, classname is used
    optional static func newForReuse() -> AnyObject? // if implemented, dequeueOrCreateReusableWithClass can be used
    optional func prepareForReuse() -> Void
}

@objc class ReusableQueue : NSObject {
    var reusables: NSCache = NSCache();
    
    static let sharedQueue = ReusableQueue()
    
    override init () {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "emptyQueue:",
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: nil)
    }
    
    func enqueueReusable(reusable: Reusable) -> Void {
        let identifier = identifierFromReusableClass(reusable.dynamicType)
        var objects: Array<Reusable> = reusables.objectForKey(identifier) as? Array<Reusable> ??  Array<Reusable>()
        reusable.prepareForReuse?()
        objects.append(reusable)
        reusables.setObject(objects, forKey: identifier)
    }
    
    func dequeueReusableWithIdentifier(identifier: String) -> Reusable? {
        if var objects: Array<Reusable> = reusables.objectForKey(identifier) as? Array<Reusable> where
            objects.count > 0{
            let reusable = objects.removeFirst()
            reusables.setObject(objects, forKey: identifier)
            return reusable
        }
        return nil
    }
    
    func dequeueReusableWithClass(reusableClass: Reusable.Type) -> Reusable? {
        return dequeueReusableWithIdentifier(identifierFromReusableClass(reusableClass))
    }
    
    func dequeueOrCreateReusableWithClass(reusableClass: Reusable.Type) -> Reusable? {
        if let reusable = dequeueReusableWithClass(reusableClass) {
            return reusable
        }
        let createdReusable = reusableClass.newForReuse?()
        if let reusable = createdReusable as? Reusable {
            return reusable
        }
        return nil
    }
    
    func emptyQueue() -> Void {
        reusables.removeAllObjects()
    }
    
    private func identifierFromReusableClass(reusable: Reusable.Type) -> String {
        if let identifier = reusable.reuseIdentifier?() {
            return identifier
        }
        return  "\(reusable)"
    }
    
}