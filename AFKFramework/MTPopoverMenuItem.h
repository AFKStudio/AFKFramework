//
//  MTPopoverMenuItem.h
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "MTPopoverMenu.h"
#import "MTPopoverMenuView.h"


@interface MTPopoverMenuItem : NSObject <MTPopoverMenuDrawable, MTPopoverMenuSelectable> {
    NSString __strong *_label;
    NSString __strong *_shortcut;

    void(^_completionBlock)();
    
    BOOL _selected;
    
    MTPopoverMenuStyle _menuStyle;
}


@property (strong) NSString *label;
@property (strong) NSString *shortcut;

@property (copy) void(^completionBlock)();

@property BOOL selected;

@property MTPopoverMenuStyle menuStyle;


- (id) initWithcompletionBlock:(void (^)()) completionBlock label:(NSString *) label shortcut:(NSString *) shortcut;

- (void) drawInRect:(NSRect) rect;

- (void) invoke;

@end
