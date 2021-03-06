//
//  adHexFormatter.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/9/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "adHexFormatter.h"

@implementation adHexFormatter

- (NSString *)stringForObjectValue:(id)obj
{
	if (![obj isKindOfClass:[NSNumber class]])
	{
		return nil;
	}
	
	NSUInteger value = ((NSNumber *)obj).unsignedIntegerValue;
	if (!value)
	{
		return @"0x00";
	}
	
	NSString *output = @"";
	
	// I'm sure there's a way to do this more efficiently.
	do
	{
		NSUInteger hexPair = value & 0xFF;
		value = value >> 8;
		@autoreleasepool
		{
			NSString *pairString = [NSString stringWithFormat:@"%02lX", (unsigned long)hexPair];
			output = [pairString stringByAppendingString:output];
		}
	}
	while (value);
	
	return [@"0x" stringByAppendingString:output];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj
			 forString:(NSString *)string
	  errorDescription:(out NSString *__autoreleasing *)error
{
	unsigned int intResult;
	BOOL returnValue = NO;
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	if ([scanner scanHexInt:&intResult] && scanner.isAtEnd)
	{
		returnValue = YES;
		if (obj)
		{
			*obj = [NSNumber numberWithUnsignedInt:intResult];
		}
	}
	else
	{
		if (error)
		{
			*error = NSLocalizedString(@"Couldn't convert hex to int", @"Error converting");
		}
	}
	
	
	return returnValue;
}

@end
