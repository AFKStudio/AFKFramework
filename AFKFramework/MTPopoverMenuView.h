//
//  MTPopoverMenuView.h
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum {
    MTPopoverMenuStyleNormal,
    MTPOpoverMenuStyleHUD
} MTPopoverMenuStyle;


@protocol MTPopoverMenuDrawable <NSObject>

@property MTPopoverMenuStyle menuStyle;


- (NSSize) preferredSizeForLabel;
- (NSSize) preferredSizeForShortcut;

- (void) drawInRect:(NSRect) rect;

@end


@class MTPopoverMenuView;

@protocol MTPopoverMenuDataSource <NSObject>

- (NSUInteger) popoverMenuViewItemCount:(MTPopoverMenuView *) menuView;
- (id <MTPopoverMenuDrawable>) popoverMenuView:(MTPopoverMenuView *) menuView itemAtIndex:(NSUInteger) index;

@end


@interface MTPopoverMenuView : NSView {
    NSMutableArray __strong *itemFrames;
    
    __unsafe_unretained id <MTPopoverMenuDataSource> _dataSource;
    
    MTPopoverMenuStyle _menuStyle;
}


@property (nonatomic,unsafe_unretained) id <MTPopoverMenuDataSource> dataSource;

@property MTPopoverMenuStyle menuStyle;


- (void) reload;
- (void) invalidateItemsAtIndices:(NSIndexSet *) indices;

- (NSUInteger) indexOfItemAtPoint:(NSPoint) point;


@end
