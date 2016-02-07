//
//  BRReusableQueue.h
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 07.02.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRReusable <NSObject>

@optional

+ (NSString *)reuseIdentifier;
+ (instancetype)newForReuse __attribute__((ns_returns_not_retained));
- (void)prepareForReuse;

@end

@interface BRReusableQueue : NSObject

@property (assign) BOOL emptyOnMemoryWarningNotification;

+ (instancetype)sharedQueue;

- (void)enqueueReusable:(id <BRReusable>)reusable;

- (id <BRReusable>)dequeueReusableWithIdentifier:(NSString *)identifier;
- (id <BRReusable>)dequeueReusableWithClass:(Class)reuseClass;
- (id <BRReusable>)dequeueOrCreateReusableWithClass:(Class)reusableClass;

- (void)emptyQueue;

@end
