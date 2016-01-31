# BRReuseableQueue

ReuseableQueue is a simple, private api free queue you can use to reuse every object.

## How to get startet

### install via [CocoaPods](http://cocoapods.org/)
The best way to install BRReuseableQueue is via Cocoapods.

```
pod 'BRReuseQueue'
use_frameworks!
```

### Swift Usage

```
// Import BRReusableQueue
import BRReusableQueue

// get hold of your queue
let reusableQueue = ReusableQueue.sharedQueue // or you can create your own one

// enqueue an object you don't need
let reusableObject = ReusableClass()
reusableQueue.enqueueReusable(reusableObject)

// dequeue the object
reusableQueue.dequeueReusableWithClass(ReusableClass)
```

### Objective-C Usage

```
// Import BRReusableQueue
@import BRReusableQueue;

// get hold of your queue
ReusableQueue *reusableQueue = [ReusableQueue sharedQueue]; // or you can create your own one

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

```
optional static func reuseIdentifier() -> String
```

### Easy creation of objects

Per default you can only use the `dequeueReusableWithIdentifier` and `dequeueReusableWithClass` method to get hold of an object. Those methods return nil if there is no object in the queue for the given identifier.

The `dequeueOrCreateReusableWithClass` will dequeue an object and create a new one if none was found.

```
optional static func newForReuse() -> AnyObject?
```

### Prepare for reuse

Every object that gets enqueued in the reusableQueue is called the `prepareForReuse` method. Use it to reset it to a default state and get rid of everything you don't need.

```
optional func prepareForReuse() -> Void
```