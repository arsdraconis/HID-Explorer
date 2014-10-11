//
//  HXElementInspectorViewController.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ElementTreeNode, HIDElement;

@interface HXElementInspectorViewController : NSViewController <NSOutlineViewDelegate>

@property IBOutlet NSOutlineView *elementsOutlineView;
@property IBOutlet NSTreeController *elementsTreeController;
@property ElementTreeNode *rootNode;

@property HIDElement *selectedElement;
@property NSString *usagePage;
@property NSString *usageID;


@end
