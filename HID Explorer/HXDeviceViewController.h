//
//  HXDeviceViewController.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HIDElement, ElementTreeNode;

@interface HXDeviceViewController : NSViewController

@property IBOutlet NSOutlineView *elementsOutlineView;
@property IBOutlet NSTreeController *elementsTreeController;
@property ElementTreeNode *rootNode;

@end
