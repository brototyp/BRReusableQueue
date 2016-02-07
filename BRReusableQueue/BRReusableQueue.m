//
//  BRReusableQueue.m
//  BRReusableQueue
//
//  Created by Cornelius Horstmann on 07.02.16.
//  Copyright © 2016 Cornelius Horstmann. All rights reserved.
//

#import "BRReusableQueue.h"
#import <UIKit/UIKit.h>

@implementation BRReusableQueue {
    NSCache *_reusables;
}

+ (instancetype)sharedQueue {
    static dispatch_once_t onceToken;
    static BRReusableQueue *sharedQueue;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[BRReusableQueue alloc] init];
    });
    return sharedQueue;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self ) {
        _reusables = [NSCache new];
        self.emptyOnMemoryWarningNotification = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)enqueueReusable:(id <BRReusable>)reusable {
    NSString *identifier = [self identifierFromReusableClass:[reusable class]];
    NSMutableArray *objects = [[_reusables objectForKey:identifier] mutableCopy];
    if (!objects) {
        objects = [NSMutableArray new];
    }
    if ([reusable respondsToSelector:@selector(prepareForReuse)]) {
        [reusable performSelector:@selector(prepareForReuse)];
    }
    [objects addObject:reusable];
    [_reusables setObject:objects forKey:identifier];
}

- (id <BRReusable>)dequeueReusableWithIdentifier:(NSString *)identifier {
    NSMutableArray *objects = [_reusables objectForKey:identifier];
    if (!objects) {
        return nil;
    }
    id<BRReusable> object = [objects lastObject];
    if (!object) {
        return nil;
    }
    [objects removeObject:object];
    [_reusables setObject:objects forKey:identifier];
    return object;
}

- (id <BRReusable>)dequeueReusableWithClass:(Class)reuseClass {
    return [self dequeueReusableWithIdentifier:[self identifierFromReusableClass:reuseClass]];
}

- (id <BRReusable>)dequeueOrCreateReusableWithClass:(Class)reusableClass {
    id <BRReusable> reusable = [self dequeueReusableWithClass:reusableClass];
    if (reusable) {
        return reusable;
    }
    if (![reusableClass respondsToSelector:@selector(newForReuse)]) {
        return nil;
    }
    reusable = [reusableClass performSelector:@selector(newForReuse)];
    return reusable;
}

- (void)emptyQueue {
    [_reusables removeAllObjects];
}

#pragma mark private

- (NSString *)identifierFromReusableClass:(Class)reusableClass {
    if ([reusableClass respondsToSelector:@selector(reuseIdentifier)]) {
        return [reusableClass performSelector:@selector(reuseIdentifier)];
    }
    return NSStringFromClass(reusableClass);
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification {
    if (!self.emptyOnMemoryWarningNotification) {
        return;
    }
    [self emptyQueue];
}

@end
