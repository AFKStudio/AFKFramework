//
//  MTPopoverMenuItem.m
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import "MTPopoverMenuItem.h"


@implementation MTPopoverMenuItem
@synthesize label=_label;
@synthesize shortcut=_shortcut;
@synthesize completionBlock=_completionBlock;
@synthesize selected=_selected;
@synthesize menuStyle=_menuStyle;


#pragma mark -
#pragma mark Measurements and drawing


- (NSMutableDictionary *) drawingAttributes {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setObject:[NSFont menuFontOfSize:0]
                   forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
    
    if (self.selected) {
        [attributes setObject:[NSColor selectedMenuItemTextColor]
                       forKey:NSForegroundColorAttributeName];
        
        [attributes setObject:[NSColor selectedMenuItemColor]
                       forKey:NSBackgroundColorAttributeName];
    } else {
        if (self.menuStyle == MTPopoverMenuStyleNormal) {
            [attributes setObject:[NSColor controlTextColor]
                           forKey:NSForegroundColorAttributeName];

            [attributes setObject:[NSColor clearColor]
                           forKey:NSBackgroundColorAttributeName];

            NSShadow *shadow = [NSShadow new];
            
            shadow.shadowColor = [NSColor whiteColor];
            shadow.shadowOffset = NSMakeSize(0.0, -1.0);
            shadow.shadowBlurRadius = 1.0;
            
            [attributes setObject:shadow
                           forKey:NSShadowAttributeName];
        } else {
            [attributes setObject:[NSColor colorWithDeviceWhite:0.95 alpha:1.0]
                           forKey:NSForegroundColorAttributeName];
            
            [attributes setObject:[NSColor clearColor]
                           forKey:NSBackgroundColorAttributeName];
            
        }
    }
    
    return attributes;
}


- (void) drawInRect:(NSRect) rect {
    [NSGraphicsContext saveGraphicsState];
    
    NSMutableDictionary *attributes = [self drawingAttributes];
    
    if (self.selected) {
        [[NSColor selectedMenuItemColor] setFill];
    } else {
        if (self.menuStyle == MTPopoverMenuStyleNormal) {
            [[NSColor clearColor] setFill];
        } else {
            [[NSColor clearColor] setFill];
        }
    }

    [[NSBezierPath bezierPathWithRect:rect] fill];

    rect = NSInsetRect(rect, 10, 0.0);
    
    ((NSMutableParagraphStyle *) [attributes objectForKey:NSParagraphStyleAttributeName]).alignment = NSRightTextAlignment;
    
    [self.shortcut drawInRect:rect
               withAttributes:attributes];

    [attributes removeObjectForKey:NSParagraphStyleAttributeName];
    
    [self.label drawInRect:rect
            withAttributes:attributes];
    
    [NSGraphicsContext restoreGraphicsState];
}


- (NSSize) preferredSizeForLabel {
    return [self.label sizeWithAttributes:[self drawingAttributes]];
}


- (NSSize) preferredSizeForShortcut {
    return [self.shortcut sizeWithAttributes:[self drawingAttributes]];
}


#pragma mark -
#pragma mark Selection management


- (BOOL) selectable {
    return YES;
}


- (void) invoke {
    self.completionBlock();
}


#pragma mark -
#pragma mark Initialization and memory management


- (id) initWithcompletionBlock:(void (^)()) completionBlock label:(NSString *) label shortcut:(NSString *) shortcut {
    self = [super init];
    
    if (self) {
        self.completionBlock = completionBlock;
        
        self.label = label;
        self.shortcut = shortcut;
    }
    
    return self;
}


@end
