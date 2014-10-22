//
//  HXSourceListItem.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/14/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIDDevice;

@interface HXSourceListItem : NSObject

@property (readonly) BOOL isLeaf;
@property (readonly) NSMutableArray *children;

@property (readonly) NSString *name;
@property (readonly) NSImage *image;

@property (readonly) HIDDevice *device;

+ (instancetype)itemWithGroupName:(NSString *)name
						 children:(NSArray *)children;
+ (instancetype)itemWithDevice:(HIDDevice *)device;

+ (instancetype)findNodeInArray:(NSArray *)array withGroupName:(NSString *)name;
+ (HXSourceListItem *)insertDevice:(HIDDevice *)device intoTree:(NSArray *)rootArray;
+ (void)removeNodeWithDevice:(HIDDevice *)device inTree:(NSMutableArray *)rootArray;
+ (void)sortTree:(NSMutableArray *)rootArray;

@end
