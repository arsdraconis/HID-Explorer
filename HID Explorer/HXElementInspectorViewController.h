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

@property HIDElement *selectedElement;
@property NSString *usagePage;
@property NSString *usageID;


@end
