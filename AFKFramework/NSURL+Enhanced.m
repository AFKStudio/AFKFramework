//
//  NSURL+Enhanced.m
//  Tunesque
//
//  Created by Marco Tabini on 11-08-17.
//  Copyright (c) 2011 Marco Tabini. All rights reserved.
//

#import "NSURL+Enhanced.h"

@implementation NSURL (Enhanced)


- (NSURL *)URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];

    return theURL;
}


@end
