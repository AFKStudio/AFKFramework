//
//  MTPopoverMenuSeparator.m
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import "MTPopoverMenuSeparator.h"

@implementation MTPopoverMenuSeparator
@synthesize menuStyle=_menuStyle;


#pragma mark -
#pragma mark Drawing and measurements


- (NSSize) preferredSizeForLabel {
    return NSMakeSize(0.0, 9.0);
}


- (NSSize) preferredSizeForShortcut {
    return NSMakeSize(0.0, 9.0);
}


- (void) drawInRect:(NSRect) rect {
    [NSGraphicsContext saveGraphicsState];
    
    if (self.menuStyle == MTPopoverMenuStyleNormal) {
        NSShadow *shadow = [NSShadow new];
        
        shadow.shadowColor = [NSColor whiteColor];
        shadow.shadowOffset = NSMakeSize(0.0, -1.0);
        shadow.shadowBlurRadius = 1.0;
        
        [shadow set];
        
        [[NSColor disabledControlTextColor] setStroke];
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        
        [path moveToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect) + NSHeight(rect) / 2 + 1)];
        [path lineToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + NSHeight(rect) / 2 + 1)];
        
        path.lineWidth = 1.0;
        
        [path stroke];
    } else {
        [[NSColor colorWithDeviceWhite:0.9 alpha:1.0] setStroke];
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        
        [path moveToPoint:NSMakePoint(NSMinX(rect), NSMinY(rect) + NSHeight(rect) / 2 + 0.5)];
        [path lineToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + NSHeight(rect) / 2 + 0.5)];
        
        path.lineWidth = 0.5;
        
        [path stroke];
    }
    
    [NSGraphicsContext restoreGraphicsState];
}


#pragma mark -
#pragma mark Selection management


- (BOOL) selected {
    return NO;
}


- (void) setSelected:(BOOL)selected {
    NSAssert(false, @"Attempting to select an instance of MTPopoverMenuSeparator");
}


- (BOOL) selectable {
    return NO;
}


- (void) invoke {
    NSAssert(false, @"Attempting to invoke an instance of MTPopoverMenuSeparator");
}


@end
