//
//  HXDeviceViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "ElementTreeNode.h"

#import "HXDeviceViewController.h"
#import "HXElementInspectorViewController.h"

extern const NSString * HIDDeviceUsagePairsUsageKey;
extern const NSString * HIDDeviceUsagePairsUsagePageKey;

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXDeviceViewController ()

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXDeviceViewController


//------------------------------------------------------------------------------
#pragma mark Populating the Usage Pairs Table
//------------------------------------------------------------------------------
- (void)populateUsagePairs:(HIDDevice *)device
{
	// Loop through the usage pairs and add them to a dictionary.
	// If they're the same as the primary usage pairs, add a key to reflect that.
	// Add the dictionary to the array.
	self.usagePairs = [NSMutableArray array];
	
	NSArray *pairs = device.deviceUsagePairs;
	for (NSDictionary *pair in pairs)
	{
		NSMutableDictionary *newPair = [NSMutableDictionary dictionaryWithDictionary:pair];
		NSNumber *usage = newPair[HIDDeviceUsagePairsUsageKey];
		NSNumber *usagePage = newPair[HIDDeviceUsagePairsUsagePageKey];
		
		if (usage.unsignedIntegerValue	   == device.primaryUsage &&
			usagePage.unsignedIntegerValue == device.primaryUsagePage)
		{
			newPair[@"isPrimary"] = [NSNumber numberWithBool:YES];
		}
		else
		{
			newPair[@"isPrimary"] = [NSNumber numberWithBool:NO];
		}
	}
	
	[self.usagePairsArrayController setContent:self.usagePairs];
}


//------------------------------------------------------------------------------
#pragma mark View Lifecycle
//------------------------------------------------------------------------------
- (void)viewWillAppear
{
	HIDDevice *device = (HIDDevice *)(self.parentViewController.representedObject);
	self.representedObject = device;
	
	[self populateUsagePairs:device];
}


@end
