//
//  MTPopoverMenuSeparator.h
//  Pastemore
//
//  Created by Marco Tabini on 11-06-09.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTPopoverMenu.h"
#import "MTPopoverMenuView.h"


@interface MTPopoverMenuSeparator : NSObject <MTPopoverMenuDrawable, MTPopoverMenuSelectable> {
    MTPopoverMenuStyle _menuStyle;
}


@property BOOL selected;

@property MTPopoverMenuStyle menuStyle;


@end
