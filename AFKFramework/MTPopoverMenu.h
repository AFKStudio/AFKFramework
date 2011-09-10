//
//  MTPopoverMenu.h
//  Pastemore
//
//  Created by Marco Tabini on 11-06-08.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTPopoverMenuView.h"


@protocol MTPopoverMenuSelectable <NSObject>

@property BOOL selected;


- (BOOL) selectable;

- (void) invoke;


@end


@class MTPopoverMenu;


@protocol MTPOpoverMenuDelegate <NSObject>

- (void) popoverDidClose:(MTPopoverMenu *) popover;

@end


@interface MTPopoverMenu : NSViewController <MTPopoverMenuDataSource, NSPopoverDelegate> {
    NSPopover __strong *_popover;
    
    NSArray *_items;
    
    NSUInteger _selectedIndex;
    
    __unsafe_unretained id <MTPOpoverMenuDelegate> _delegate;
    
    MTPopoverMenuStyle _menuStyle;
}


@property (strong) NSPopover *popover;

@property (nonatomic,strong) NSArray *items;

@property (nonatomic) NSUInteger selectedIndex;

@property (unsafe_unretained) id <MTPOpoverMenuDelegate> delegate;

@property (nonatomic) MTPopoverMenuStyle menuStyle;


- (id) initWithMenuItems:(NSArray *) menuItems;

- (void) showPanelForView:(NSView *)view highlightingFirstItem:(BOOL)highlightFirstItem preferredEdge:(NSRectEdge) rectEdge;
- (void) showPanelForView:(NSView *) view highlightingFirstItem:(BOOL) highlightFirstItem;

- (void) closePanel;


@end
