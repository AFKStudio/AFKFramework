//
//  MTPopoverMenuView.m
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import "MTPopoverMenuView.h"

#import <Carbon/Carbon.h>

#import "MTPopoverMenuItem.h"


@implementation MTPopoverMenuView
@synthesize dataSource=_dataSource;
@synthesize menuStyle=_menuStyle;


#pragma mark -
#pragma mark Measurements and drawing


- (void) setFrame:(NSRect)frameRect {
    super.frame = frameRect;
    
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
    
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds
                                                       options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                                                               NSTrackingActiveAlways | NSTrackingAssumeInside
                                                         owner:self
                                                      userInfo:Nil]];
}


- (BOOL) isFlipped {
    return YES;
}


- (void) drawRect:(NSRect)dirtyRect {
    NSRect itemFrame = NSZeroRect;
    itemFrame.size.width = NSWidth(self.bounds);
    
    NSUInteger count = itemFrames.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        NSRect itemFrame = [[itemFrames objectAtIndex:i] rectValue];
        
        if (NSIntersectsRect(dirtyRect, itemFrame)) {
            id <MTPopoverMenuDrawable> item = [self.dataSource popoverMenuView:self itemAtIndex:i];
            item.menuStyle = self.menuStyle;
            [item drawInRect:itemFrame];
        }
    }
}


- (NSUInteger) indexOfItemAtPoint:(NSPoint) point {
    NSUInteger count = itemFrames.count;
    
    for (NSUInteger index = 0; index < count; index++) {
        NSValue *value = [itemFrames objectAtIndex:index];
        
        if (NSPointInRect(point, [value rectValue])) {
            return index;
        }
    }

    return NSNotFound;
}


- (void) invalidateItemsAtIndices:(NSIndexSet *) indices {
    for (NSValue *value in itemFrames) {
        [self setNeedsDisplayInRect:[value rectValue]];
    }
}


#pragma mark -
#pragma mark Datasource management


- (void) reload {
    NSMutableArray *myItemFrames = [NSMutableArray new];
    
    NSUInteger count = [self.dataSource popoverMenuViewItemCount:self];
    NSRect frame = NSZeroRect;
    
    frame.size.height += 5;
    
    CGFloat maxLabelWidth = 0;
    CGFloat maxShortcutWidth = 0;
    
    for (NSUInteger i = 0; i < count; i++) {
        id <MTPopoverMenuDrawable> item = [self.dataSource popoverMenuView:self itemAtIndex:i];
        
        NSSize preferredSizeForLabel = [item preferredSizeForLabel];
        NSSize preferredSizeForShortcut = [item preferredSizeForShortcut];
        
        NSRect itemFrame = NSZeroRect;
        
        itemFrame.origin.y = NSHeight(frame);
        itemFrame.size.width = preferredSizeForLabel.width + preferredSizeForShortcut.width + 20;
        itemFrame.size.height = MAX(preferredSizeForLabel.height, preferredSizeForShortcut.height);

        [myItemFrames addObject:[NSValue valueWithRect:itemFrame]];
        
        
        maxLabelWidth = MAX(maxLabelWidth, preferredSizeForLabel.width);
        maxShortcutWidth = MAX(maxShortcutWidth, preferredSizeForShortcut.width);
        
        frame.size.height += itemFrame.size.height;
    }
    
    frame.size.width = maxLabelWidth + maxShortcutWidth + 40;
    
    // Second pass—make all the frames the same width
    
    itemFrames = [NSMutableArray arrayWithCapacity:myItemFrames.count];
    
    for (NSValue *value in myItemFrames) {
        NSRect itemFrame = [value rectValue];
        
        itemFrame.size.width = frame.size.width;
        
        [itemFrames addObject:[NSValue valueWithRect:itemFrame]];
    }
    
    frame.size.height += 5;
    
    self.frame = frame;
    [self setNeedsDisplay:YES];
}


- (void) setDataSource:(id<MTPopoverMenuDataSource>)dataSource {
    [self willChangeValueForKey:@"dataSource"];
    
    _dataSource = dataSource;
    
    [self didChangeValueForKey:@"dataSource"];
}


#pragma mark -
#pragma mark Initialization and memory management


- (BOOL) acceptsFirstResponder {
    return YES;
}


- (id) init {
    self = [super initWithFrame:NSZeroRect];
    
    if (self) {
        itemFrames = [NSMutableArray new];
    }
    
    return self;
}

@end
