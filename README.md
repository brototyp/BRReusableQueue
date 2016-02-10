# BRReuseableQueue

ReuseableQueue is a simple, private api free queue you can use to reuse every object.

## How to get startet

### install via [CocoaPods](http://cocoapods.org/)
The best way to install BRReuseableQueue is via CocoaPods.

#### Swift
```ruby
pod 'BRReuseQueue/Swift'
use_frameworks!
```

#### Objc
```ruby
pod 'BRReuseQueue/OBJC'
```

### Swift Usage

```swift
// Import BRReusableQueue
import BRReusableQueue

// get hold of your queue
let reusableQueue = BRReusableQueue.sharedQueue // or you can create your own one

// enqueue an object you don't need
let reusableObject = ReusableClass()
reusableQueue.enqueueReusable(reusableObject)

// dequeue the object
reusableQueue.dequeueReusableWithClass(ReusableClass)
```

### Objective-C Usage

```objc
// Import BRReusableQueue
@import BRReusableQueue;

// get hold of your queue
ReusableQueue *reusableQueue = [BRReusableQueue sharedQueue]; // or you can create your own one

// enqueue an object you don't need
ReusableClass *reusableObject = [ReusableClass new];
[reusableQueue enqueueReusable:reusableObject];

// dequeue the object
[reusableQueue dequeueReusableWithClass:ReusableClass];
```

## Custom Reusable Class

All objects stored in a ReusableQueue must implement the `Reusable` protocol. All methods in the protocol are optional and are there to help you customize the queue.

### Custom reuseIdentifier

Per default the reuseIdentifier is the class name of an object. You can change that behavior by implementing the `reuseIdentifier`.

```swift
optional static func reuseIdentifier() -> String
```

### Easy creation of objects

Per default you can only use the `dequeueReusableWithIdentifier` and `dequeueReusableWithClass` method to get hold of an object. Those methods return nil if there is no object in the queue for the given identifier.

The `dequeueOrCreateReusableWithClass` will dequeue an object and create a new one if none was found.

```swift
optional static func newForReuse() -> AnyObject?
```

### Prepare for reuse

Every object that gets enqueued in the reusableQueue is called the `prepareForReuse` method. Use it to reset it to a default state and get rid of everything you don't need.

```swift
optional func prepareForReuse() -> Void
```

## Development

Both variants (Swift/Objc) live side by side. The Objc variant exists so Objc only projects can use it without requiring the Swift runtime. The Swift variant exists because I wanted to play around in Swift. 

This Setup makes testing a bit hard. The test code should test both variants the exact same way. To toggle between testing Swift / Objc code please change (un-)comment the line in `BRReusableQueue-Bridging-Header.h` and `BRReusableQueueTests.swift:12`. I am still searching for a way to optimize this.