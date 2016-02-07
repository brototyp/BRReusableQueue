//
//  BRReusableQueueTests.swift
//  BRReusableQueueTests
//
//  Created by Cornelius Horstmann on 30.01.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

import XCTest

// commet this if you want to test the objc-code
@testable import BRReusableQueue

class DefaultTestReusable : NSObject, BRReusable {
    var count = 0
    
    @objc func prepareForReuse() {
        count += 1
    }
}

class CreateableTestReusable : DefaultTestReusable {
    static func newForReuse() -> AnyObject? {
        return CreateableTestReusable()
    }
}

class CustomIdentifierTestReusable : DefaultTestReusable {
    static func reuseIdentifier() -> String {
        return "CustomIdentifier"
    }
}

class BRReusableQueueTests: XCTestCase {
    
    let reusableQueue = BRReusableQueue()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        reusableQueue.emptyQueue()
    }
    
    func testDequeueReusableWithClass() {
        let reusable = DefaultTestReusable()
        reusableQueue.enqueueReusable(reusable)
        let reused = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertEqual(reusable, reused as? DefaultTestReusable)
    }
    
    func testDequeueReusableWithIdentifier() {
        let reusable = CustomIdentifierTestReusable()
        reusableQueue.enqueueReusable(reusable)
        let reused = reusableQueue.dequeueReusableWithIdentifier(CustomIdentifierTestReusable.reuseIdentifier())
        XCTAssertEqual(reusable, reused as? CustomIdentifierTestReusable)
    }
    
    func testDequeueCreateReusable() {
        let created = reusableQueue.dequeueOrCreateReusableWithClass(CreateableTestReusable)
        XCTAssertNotNil(created)
    }
    
    func testPrepareForReuse() {
        let reusable = DefaultTestReusable()
        let oldCount = reusable.count
        reusableQueue.enqueueReusable(reusable)
        let reused = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertEqual(reusable, reused as? DefaultTestReusable)
        XCTAssertNotEqual(oldCount, (reused as! DefaultTestReusable).count)
    }
    
    func testDequeueMoreThanThereIs() {
        let reusable = DefaultTestReusable()
        reusableQueue.enqueueReusable(reusable)
        let reused = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        let nonexisting = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertEqual(reusable, reused as? DefaultTestReusable)
        XCTAssertNil(nonexisting)
    }
    
    func testEmptyingQueue() {
        let reusable = DefaultTestReusable()
        reusableQueue.enqueueReusable(reusable)
        reusableQueue.emptyQueue()
        let nonexisting = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertNil(nonexisting)
    }
    
    func testAutomaticEmptyingQueue() {
        let reusable = DefaultTestReusable()
        reusableQueue.enqueueReusable(reusable)
        reusableQueue.emptyOnMemoryWarningNotification = true
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        let nonexisting = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertNil(nonexisting)
    }
    
    func testNonAutomaticEmptyingQueue() {
        let reusable = DefaultTestReusable()
        reusableQueue.enqueueReusable(reusable)
        reusableQueue.emptyOnMemoryWarningNotification = false
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        let existing = reusableQueue.dequeueReusableWithClass(DefaultTestReusable)
        XCTAssertNotNil(existing)
    }
    
    // this test does always succeed; is there a way to let it fail if the object is still registered
    func testRemovingObserverOnDealloc() {
        var deInitableReusableQueue : BRReusableQueue? = BRReusableQueue()
        let reusable = DefaultTestReusable()
        deInitableReusableQueue!.enqueueReusable(reusable)
        deInitableReusableQueue = nil
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
}
