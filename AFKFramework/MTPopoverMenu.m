//
//  MTPopoverMenu.m
//  Pastemore
//
//  Created by Marco Tabini on 11-06-08.
//  Copyright 2011 Marco Tabini & Associates, Inc. All rights reserved.
//

#import "MTPopoverMenu.h"

#import <Carbon/Carbon.h>

#import "NSObject+Enhanced.h"

#import "MTPopoverMenuItem.h"


@implementation MTPopoverMenu
@synthesize popover=_popover;
@synthesize selectedIndex=_selectedIndex;
@synthesize items=_items;
@synthesize delegate=_delegate;
@synthesize menuStyle=_menuStyle;


#pragma mark - Properties


- (void) setMenuStyle:(MTPopoverMenuStyle)menuStyle {
    [self willChangeValueForKey:@"menuStyle"];
    _menuStyle = menuStyle;
    [self didChangeValueForKey:@"menuStyle"];
    
    ((MTPopoverMenuView *) self.view).menuStyle = menuStyle;
}


#pragma mark -
#pragma mark Item management


- (void) setItems:(NSArray *)items {
    [self willChangeValueForKey:@"items"];
    
    _items = items;
    
    [((MTPopoverMenuView *) self.view) reload];
    
    [self didChangeValueForKey:@"items"];
}


- (NSUInteger) popoverMenuViewItemCount:(MTPopoverMenuView *)menuView {
    return self.items.count;
}


- (id <MTPopoverMenuDrawable>) popoverMenuView:(MTPopoverMenuView *)menuView itemAtIndex:(NSUInteger)index {
    return [self.items objectAtIndex:index];
}


#pragma mark -
#pragma mark Selection management


- (void) setSelectedIndex:(NSUInteger)selectedIndex force:(BOOL) force {
    if (!force && selectedIndex == self.selectedIndex) {
        return;
    }
    
    NSMutableIndexSet *indexesToInvalidate = [NSMutableIndexSet indexSet];
    
    if (self.selectedIndex != NSNotFound) {
        ((id <MTPopoverMenuSelectable>) [self.items objectAtIndex:self.selectedIndex]).selected = NO;
        [indexesToInvalidate addIndex:self.selectedIndex];
    }
    
    [self willChangeValueForKey:@"selectedIndex"];
    
    _selectedIndex = selectedIndex;
    
    if (selectedIndex != NSNotFound) {
        ((id <MTPopoverMenuSelectable>) [self.items objectAtIndex:selectedIndex]).selected = YES;
        [indexesToInvalidate addIndex:selectedIndex];
    }
    
    [((MTPopoverMenuView *) self.view) invalidateItemsAtIndices:indexesToInvalidate];

    [self didChangeValueForKey:@"selectedIndex"];
}


- (void) setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex force:NO];
}


- (NSUInteger) nextSelectableIndex {
    NSUInteger i = self.selectedIndex;
    NSUInteger count = self.items.count;
    
    if (i == NSNotFound) {
        i = 0;
    } else {
        i++;
    }
    
    while (i < count) {
        if ([((id <MTPopoverMenuSelectable>) [self.items objectAtIndex:i]) selectable]) {
            return i;
        }
        
        i++;
    }
    
    return NSNotFound;
}


- (NSUInteger) previousSelectableIndex {
    NSUInteger i = self.selectedIndex;
    
    if (!i) {
        return NSNotFound;
    } else {
        i--;
    }
    
    while (i != NSNotFound) {
        if ([((id <MTPopoverMenuSelectable>) [self.items objectAtIndex:i]) selectable]) {
            return i;
        }
        
        if (!i) {
            i = NSNotFound;
        } else {
            i--;
        }
    }
    
    return NSNotFound;
}


#pragma mark -
#pragma mark Event management


- (void) flashAndInvokeItemAtIndex:(NSUInteger) index {
    id <MTPopoverMenuSelectable> item = (id <MTPopoverMenuSelectable>) [self.items objectAtIndex:index];
    
    self.selectedIndex = index;
    
    [self performBlock:^(void) {
        self.selectedIndex = NSNotFound;
        
        [self performBlock:^(void) {
            self.selectedIndex = index;
            
            [self performBlock:^(void) {
                [item invoke];
                [self.popover close];
                self.popover = Nil;
            } afterDelay:0.14];
        } afterDelay:0.06];
    } afterDelay:0.06];
}


- (void) keyDown:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case kVK_Escape:
            [self.popover close];
            self.popover = Nil;
            break;
            
        case kVK_DownArrow:
            {
                NSUInteger nextIndex = [self nextSelectableIndex];
            
                if (nextIndex == NSNotFound) {
                    [self.nextResponder keyDown:theEvent];
                } else {
                    self.selectedIndex = nextIndex;
                }
            }
            break;
        
        case kVK_UpArrow:
            {
                NSUInteger previousIndex = [self previousSelectableIndex];
                
                if (previousIndex == NSNotFound) {
                    [self.nextResponder keyDown:theEvent];
                } else {
                    self.selectedIndex = previousIndex;
                }
            }
            break;
            
        case kVK_Return:
            if (self.selectedIndex != NSNotFound) {
                [self flashAndInvokeItemAtIndex:self.selectedIndex];
            } else {
                [self.nextResponder keyDown:theEvent];
            }
            break;
            
        default:
            
            for (MTPopoverMenuItem *item in self.items) {
                if (![item respondsToSelector:@selector(shortcut)] || !item.shortcut.length) {
                    continue;
                }
                
                BOOL success = YES;

                for (NSUInteger i = 0; i < item.shortcut.length; i++) {
                    NSString *currentCharacter = [item.shortcut substringWithRange:NSMakeRange(i, 1)];
                    
                    if ([currentCharacter isEqualToString:@"⌘"]) {
                        if ([theEvent modifierFlags] & NSCommandKeyMask) {
                            continue;
                        }
                    } else if ([currentCharacter isEqualToString:@"↩"]) {
                        if (theEvent.keyCode == kVK_Return) {
                            continue;
                        }
                    } else if ([currentCharacter isEqualToString:@"⌫"]) {
                        if (theEvent.keyCode == kVK_Delete) {
                            continue;
                        }
                    } else {
                        if (![currentCharacter caseInsensitiveCompare:[theEvent charactersIgnoringModifiers]]) {
                            continue;
                        }
                    }
                    
                    success = NO;
                    break;
                }
                
                if (success) {
                    [self flashAndInvokeItemAtIndex:[self.items indexOfObject:item]];
                    return;
                }
            }
            
            [self.nextResponder keyDown:theEvent];
            break;
    }
}


- (BOOL) acceptsFirstResponder {
    return YES;
}


- (BOOL) acceptsFirstMouse:(NSEvent *) theEvent {
    return YES;
}


- (void) mouseMoved:(NSEvent *)theEvent {
    NSPoint mouseLocation = [self.view convertPoint:theEvent.locationInWindow fromView:Nil];
    NSUInteger itemIndex = [((MTPopoverMenuView *) self.view) indexOfItemAtPoint:mouseLocation];
    
    if (itemIndex != NSNotFound && [((id <MTPopoverMenuSelectable>) [self.items objectAtIndex:itemIndex]) selectable]) {
        self.selectedIndex = itemIndex;
    } else {
        self.selectedIndex = NSNotFound;
    }
}


- (void) mouseEntered:(NSEvent *)theEvent {
    [self mouseMoved:theEvent];
}


- (void) mouseExited:(NSEvent *)theEvent {
    self.selectedIndex = NSNotFound;
}


- (void) mouseUp:(NSEvent *)theEvent {
    NSPoint mouseLocation = [self.view convertPoint:theEvent.locationInWindow fromView:Nil];
    NSUInteger itemIndex = [((MTPopoverMenuView *) self.view) indexOfItemAtPoint:mouseLocation];
    
    if (itemIndex != NSNotFound) {
        [self flashAndInvokeItemAtIndex:itemIndex];
    }
}


- (BOOL) resignFirstResponder {
    [self.popover close];
    self.popover = Nil;
    
    return YES;
}


#pragma mark -
#pragma mark Popover management


- (void) closePanel {
    [self.popover close];
}


- (void) showPanelForView:(NSView *)view highlightingFirstItem:(BOOL)highlightFirstItem preferredEdge:(NSRectEdge) rectEdge {
    self.popover = [[NSPopover alloc] init];
    
    self.popover.animates = YES;
    self.popover.delegate = self;
    
    self.popover.contentViewController = self;
    self.popover.behavior = NSPopoverBehaviorTransient;
    
    if (self.menuStyle == MTPOpoverMenuStyleHUD) {
        self.popover.appearance = NSPopoverAppearanceHUD;
    }
    
    [self.popover showRelativeToRect:view.bounds
                              ofView:view
                       preferredEdge:rectEdge];
    
    self.nextResponder = self.popover.nextResponder;
    self.popover.nextResponder = self;
    
    if (highlightFirstItem) {
        [self performBlock:^(void) {
            [self setSelectedIndex:0 force:YES];
            [self.popover.contentViewController.view setNeedsDisplay:YES];
        } afterDelay:0.1];
    }
}


- (void) showPanelForView:(NSView *) view highlightingFirstItem:(BOOL) highlightFirstItem {
    [self showPanelForView:view highlightingFirstItem:highlightFirstItem preferredEdge:NSMaxYEdge];
}


#pragma mark -
#pragma mark NSPopoverDelegate


- (void) popoverDidClose:(NSNotification *)notification {
    self.popover = Nil;
    [self.delegate popoverDidClose:self];
}


#pragma mark -
#pragma mark Initialization and memory management


- (id) initWithMenuItems:(NSArray *) menuItems {
    self = [super init];
    
    if (self) {
        ((MTPopoverMenuView *) self.view).dataSource = self;
        self.items = menuItems;
        
        self.selectedIndex = NSNotFound;
    }
    
    return self;
}


- (void) loadView {
    self.view = [[MTPopoverMenuView alloc] init];
    self.view.nextResponder = self;
}

- (void) dealloc {
    MTPopoverMenuView *view = ((MTPopoverMenuView *) self.view);
    
    view.dataSource = Nil;
    self.popover.delegate = Nil;
    self.delegate = Nil;
}


@end
