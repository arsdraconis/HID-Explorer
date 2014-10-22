//
//  HXUsageTableTranslator.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXUsageTableTranslator.h"


//------------------------------------------------------------------------------
#pragma mark Constants
//------------------------------------------------------------------------------
static const NSString * HXUSBHIDUsageTablesPlistFilename = @"USB HID Usage Tables";


//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXUsageTableTranslator ()

@property (readonly) NSDictionary *usageTables;

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXUsageTableTranslator

+ (id)sharedTranslator;
{
	static HXUsageTableTranslator *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		NSData *tablesData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:(NSString *)HXUSBHIDUsageTablesPlistFilename
																				   withExtension:@"plist"]];
		
		_usageTables = [NSPropertyListSerialization propertyListWithData:tablesData
																 options:NSPropertyListImmutable
																  format:NULL
																   error:nil];
	}
	return self;
}


//------------------------------------------------------------------------------
#pragma mark Translation Methods
//------------------------------------------------------------------------------
+ (NSString *)nameForUsagePage:(NSUInteger)usagePage
{
	NSString *humanName = @"Unknown Usage Page";
	NSDictionary *usageTables = [[[self class] sharedTranslator] usageTables];
	
	if (usageTables)
	{
		NSDictionary *usagePagesList = usageTables[@"UsagePages"];
		NSString *key = [NSString stringWithFormat:@"0x%02lX", usagePage];
		NSString *possibleValue = usagePagesList[key];
		
		if (possibleValue)
		{
			humanName = possibleValue;
		}
		else if (usagePage >= 0xFF00 && usagePage <= 0xFFFF)
		{
			humanName = usagePagesList[@"VendorDefinedRangeString"];
		}
		else
		{
			humanName = usagePagesList[@"ReservedRangeString"];
		}
	}
	
	return [NSString stringWithFormat:@"0x%04lX %@", (unsigned long)usagePage, humanName];
}


+ (NSString *)nameForUsagePage:(NSUInteger)usagePage usageID:(NSUInteger)usageID
{
	NSString *humanName = @"Unknown Usage ID";
	NSDictionary *usageTables = [[[self class] sharedTranslator] usageTables];
	
	if (usageTables)
	{
		NSString *tableName = [NSString stringWithFormat:@"0x%02lX", usagePage];
		NSDictionary *usageIDList = usageTables[tableName];
		
		if (usageIDList)
		{
			NSString *key = [NSString stringWithFormat:@"%02lX", (unsigned long)usageID];
			NSString *possibleValue = usageIDList[key];
			
			if (possibleValue)
			{
				humanName = possibleValue;
			}
			else if ((possibleValue = usageIDList[@"*"]))
			{
				// Enumerated values. Format string is in XML file.
				// TODO: Fix Unicode page support.
				humanName = [NSString stringWithFormat:possibleValue, (unsigned long)usageID];
			}
			else
			{
				// Usage ID not found.
				humanName = @"Reserved";
			}
		}
	}
	
	return [NSString stringWithFormat:@"0x%04lX %@", (unsigned long)usageID, humanName];
}


@end
