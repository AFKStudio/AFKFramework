//
//  NSString+Enhanced.m
//  Tunesque
//
//  Created by Marco Tabini on 11-08-19.
//  Copyright (c) 2011 Marco Tabini. All rights reserved.
//

#import "NSString+Enhanced.h"

@implementation NSString (Enhanced)


- (NSString *) stringByResolvingXMLEntities {
    return [[[self stringByReplacingOccurrencesOfString:@"&amp;"
                                           withString:@"&"] 
            stringByReplacingOccurrencesOfString:@"&lt;"
            withString:@"<"] 
            stringByReplacingOccurrencesOfString:@"&gt;"
            withString:@">"];
}


- (NSString *) stringByAddingPercentEscapes {
    CFStringRef stringRef = (__bridge CFStringRef) self;
    CFStringRef result = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                 stringRef,
                                                                 NULL,
                                                                 CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),
                                                                 kCFStringEncodingUTF8);
    
    return (__bridge_transfer NSString *) result;
}


- (NSString *) trimmedString {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
