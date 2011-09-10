//
//  NSColor+Enhanced.m
//  Tunesque
//
//  Created by Marco Tabini on 11-09-02.
//  Copyright (c) 2011 Marco Tabini. All rights reserved.
//

#import "NSColor+Enhanced.h"

#import "NSObject(Enhanced).h"

@implementation NSColor (Enhanced)


- (CGColorRef) CGColor {
    CGFloat components[4];
    
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    
    [convertedColor getRed:&components[0]
                     green:&components[1]
                      blue:&components[2]
                     alpha:&components[3]];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef result = CGColorCreate(colorspace, components);
    
    [self performBlock:^(void) {
        CFRelease(result);
    } 
            afterDelay:1.0];
    
    CFRelease(colorspace);
    
    return result;
}


@end
