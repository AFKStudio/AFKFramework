//
//  NSObject(Enhanced).h
//  AFKWriter
//
//  Created by Marco Tabini on 11-04-01.
//  Copyright 2011 Marco Tabini. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString AMBlockToken;
typedef void (^MTBlockTask)(id obj, NSDictionary *change);


@interface NSObject (Enhanced)


- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

- (id) addObserverForKeyPath:(NSString *) keyPath options:(NSKeyValueObservingOptions) options task: (MTBlockTask) task;
- (void) removeObserver:(id) observer;


@end
