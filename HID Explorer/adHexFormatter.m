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
	
	return [NSString stringWithFormat:@"%#0lX", (long)[obj integerValue]];
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
