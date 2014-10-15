//
//  HXSourceListItem.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/14/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXSourceListItem.h"

#import <HIDKit/HIDKit.h>

@implementation HXSourceListItem

+ (instancetype)itemWithDevice:(HIDDevice *)device
{
	return [[[self class] alloc] initWithDevice:device];
}

+ (instancetype)itemWithGroupName:(NSString *)name children:(NSArray *)children
{
	return [[[self class] alloc] initWithGroupName:name children:children];
}

@dynamic isLeaf;
- (BOOL)isLeaf
{
	return (self.children.count == 0);
}

- (instancetype)init
{
	NSLog(@"Method unimplemented: %s in %s, line %d.", __PRETTY_FUNCTION__, __FILE__, __LINE__);
	return nil;
}

- (instancetype)initWithGroupName:(NSString *)name children:(NSArray *)children
{
	self = [super init];
	if (self)
	{
		_name = name ? [name copy] : nil;
		_children = children ? [children mutableCopy] : [NSMutableArray array];
	}
	return self;
}

- (instancetype)initWithDevice:(HIDDevice *)device
{
	self = [self initWithGroupName:device.product children:nil];
	if (self)
	{
		_device = device;
	}
	return self;
}

@dynamic image;
- (NSImage *)image
{
	if (!self.isLeaf)
	{
		return nil;
	}
	else
	{
		return [NSImage imageNamed:NSImageNameActionTemplate];
	}
}

//------------------------------------------------------------------------------
#pragma mark Tree Manipulation
//------------------------------------------------------------------------------
+ (instancetype)findNodeInArray:(NSArray *)rootArray withGroupName:(NSString *)name
{
	id result = nil;
	for (id node in rootArray)
	{
		if ([node isKindOfClass:[HXSourceListItem class]] && [((HXSourceListItem *)node).name isEqualToString:name])
		{
			result = node;
			break;
		}
	}
	
	return result;
}

+ (void)insertDevice:(HIDDevice *)device intoTree:(NSMutableArray *)rootArray
{
	NSString *transport = nil;
	transport = device.transport ? device.transport : @"Unknown Transport";
	transport = [transport uppercaseString];
	
	HXSourceListItem *item = [HXSourceListItem itemWithDevice:device];
	HXSourceListItem *branch = [HXSourceListItem findNodeInArray:rootArray withGroupName:transport];
	if (!branch)
	{
		branch = [HXSourceListItem itemWithGroupName:transport children:nil];
		[rootArray addObject:branch];
	}
	
	[[branch mutableArrayValueForKey:@"children"] addObject:item];
}

+ (void)removeNodeWithDevice:(HIDDevice *)device inTree:(NSMutableArray *)rootArray
{
	NSString *transport = nil;
	transport = device.transport ? device.transport : @"Unknown Transport";
	transport = [transport uppercaseString];
	
	HXSourceListItem *branch = [HXSourceListItem findNodeInArray:rootArray withGroupName:transport];
	if (!branch)
	{
		[[NSException exceptionWithName:NSInternalInconsistencyException
								 reason:@"Tried to remove a source list branch that doesn't exist."
							   userInfo:nil] raise];
		return;
	}
	
	for (HXSourceListItem *item in branch.children)
	{
		if (item.device == device)
		{
			[[branch mutableArrayValueForKey:@"children"] removeObject:item];
		}
	}
	
	if (branch.children.count == 0)
	{
		[rootArray removeObject:branch];
	}
}

@end
