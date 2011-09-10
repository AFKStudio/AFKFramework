//
//  NSObject(Enhanced).m
//  AFKWriter
//
//  Created by Marco Tabini on 11-04-01.
//  Copyright 2011 Marco Tabini. All rights reserved.
//

#import "NSObject(Enhanced).h"


@interface MTBlockObserver : NSObject {
    MTBlockTask _task;
    
    id _object;
    NSString *_keyPath;
}

- (id) initAndObserveObject:(id) object keyPath:(NSString *) keyPath task:(MTBlockTask) task options:(NSKeyValueObservingOptions) options;

@end


@implementation MTBlockObserver

- (void) observeValueForKeyPath:(NSString *) aKeyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context {
    _task(object, change);
}


- (id) initAndObserveObject:(id) object keyPath:(NSString *) keyPath task:(MTBlockTask) task options:(NSKeyValueObservingOptions) options {
    self = [super init];
    
    if (self) {
        _task = task;
        _object = object;
        _keyPath = keyPath;
        
        [object addObserver:self forKeyPath:keyPath options:options context:Nil];
    }
    
    return self;
}


- (void) dealloc {
    [_object removeObserver:self forKeyPath:_keyPath];
}


@end


@interface MTBlockObserverManager : NSObject {
    NSMutableSet *_observerSet;
}
@end


@implementation MTBlockObserverManager

- (id) init {
    self = [super init];
    
    if (self) {
        _observerSet = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    _observerSet = Nil;
}

- (void) addObserver:(MTBlockObserver *) observer {
    [_observerSet addObject:observer];
}

- (void) removeObserver:(MTBlockObserver *) observer {
    [_observerSet removeObject:observer];
}

+ (MTBlockObserverManager *) globalInstance {
    static MTBlockObserverManager *globalInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        globalInstance = [[MTBlockObserverManager alloc] init];
    });
    
    return globalInstance;
}

@end


@implementation NSObject (Enhanced)


#pragma mark -
#pragma mark Delayed block execution


- (void) performBlock:(void (^)(void)) block afterDelay:(NSTimeInterval) delay {
    block = [block copy];
    
    [self performSelector:@selector(fireBlockAfterDelay:) 
               withObject:block 
               afterDelay:delay];
}


- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}


#pragma mark -
#pragma mark Block-based KVO

- (id) addObserverForKeyPath:(NSString *) keyPath options:(NSKeyValueObservingOptions) options task: (MTBlockTask) task {
    MTBlockObserver *observer = [[MTBlockObserver alloc] initAndObserveObject:self keyPath:keyPath task:task options:options];
    [[MTBlockObserverManager globalInstance] addObserver:observer];
    
    return observer;
}


- (void) removeObserver:(id) observer {
    if (observer) {
        [[MTBlockObserverManager globalInstance] removeObserver:observer];
    }
}


@end