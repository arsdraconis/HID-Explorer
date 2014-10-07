//
//  ElementTreeNode.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ElementTreeNode : NSTreeNode

@property (readonly) NSString *name;
@property (readonly) NSString *type;
@property (readonly) NSUInteger cookie;

@end
