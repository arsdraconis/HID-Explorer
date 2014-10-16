//
//  HXDeviceViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "ElementTreeNode.h"

#import "HXUsageTableTranslator.h"
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
#pragma mark View Lifecycle
//------------------------------------------------------------------------------
- (void)viewDidLoad
{
	[self bind:@"representedObject"
	  toObject:self.parentViewController.parentViewController
   withKeyPath:@"representedObject"
	   options:nil];
}

- (void)dealloc
{
	[self unbind:@"representedObject"];
}


//------------------------------------------------------------------------------
#pragma mark Populating the Usage Pairs Table
//------------------------------------------------------------------------------
- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	if (representedObject)
	{
		[self populateUsagePairs:(HIDDevice *)representedObject];
	}
}

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
		NSNumber *usageID = newPair[HIDDeviceUsagePairsUsageKey];
		NSNumber *usagePage = newPair[HIDDeviceUsagePairsUsagePageKey];
		
		// Present human readable names for the usage pairs.
		newPair[HIDDeviceUsagePairsUsagePageKey] = [HXUsageTableTranslator nameForUsagePage:usagePage.unsignedIntegerValue];
		newPair[HIDDeviceUsagePairsUsageKey] = [HXUsageTableTranslator nameForUsagePage:usagePage.unsignedIntegerValue
																				usageID:usagePage.unsignedIntegerValue];
		
		if (usageID.unsignedIntegerValue   == device.primaryUsage &&
			usagePage.unsignedIntegerValue == device.primaryUsagePage)
		{
			newPair[@"isPrimary"] = [NSNumber numberWithBool:YES];
		}
		else
		{
			newPair[@"isPrimary"] = [NSNumber numberWithBool:NO];
		}
		
		[self.usagePairsArrayController addObject:newPair];
	}
	
}


@end

