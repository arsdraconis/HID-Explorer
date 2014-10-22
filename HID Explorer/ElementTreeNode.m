//
//  ElementTreeNode.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <HIDKit/HIDKit.h>

#import "ElementTreeNode.h"
#import "HXUsageTableTranslator.h"

@implementation ElementTreeNode

@dynamic name;
- (NSString *)name
{
	HIDElement *element = self.representedObject;
	return element.name;
}

@dynamic type;
- (NSString *)type
{
	HIDElement *element = self.representedObject;
	IOHIDElementType type = element.type;
	
	NSString *ret;
	
	switch (type)
	{
		case kIOHIDElementTypeInput_Misc:
			ret = @"Misc. Input";
			break;
		
		case kIOHIDElementTypeInput_Button:
			ret = @"Button Input";
			break;
			
		case kIOHIDElementTypeInput_Axis:
			ret = @"Axis Input";
			break;
			
		case kIOHIDElementTypeInput_ScanCodes:
			ret = @"Scan Code Input";
			break;
			
		case kIOHIDElementTypeFeature:
			ret = @"Feature";
			break;
			
		case kIOHIDElementTypeOutput:
			ret = @"Output";
			break;
			
		case kIOHIDElementTypeCollection:
		{
			NSString *collectionType = [self collectionTypeForElement:element];
			ret = [NSString stringWithFormat:@"Collection - %@", collectionType];
			break;
		}
			
		default:
			ret = [NSString stringWithFormat:@"Unknown (%lu)", (NSUInteger)type];
			break;
	}
	
	return ret;
}

@dynamic cookie;
- (NSUInteger)cookie
{
	HIDElement *element = self.representedObject;
	return (NSUInteger)element.cookie;
}

- (NSString *)collectionTypeForElement:(HIDElement *)element
{
	IOHIDElementCollectionType type = element.collectionType;
	
	NSString *ret;
	
	switch (type)
	{
		case kIOHIDElementCollectionTypeApplication:
			ret = @"Application";
			break;
			
		case kIOHIDElementCollectionTypeLogical:
			ret = @"Logical";
			break;
			
		case kIOHIDElementCollectionTypeNamedArray:
			ret = @"Named Array";
			break;
			
		case kIOHIDElementCollectionTypePhysical:
			ret = @"Physical";
			break;
			
		case kIOHIDElementCollectionTypeReport:
			ret = @"Report";
			break;
			
		case kIOHIDElementCollectionTypeUsageModifier:
			ret = @"Usage Modifier";
			break;
			
		case kIOHIDElementCollectionTypeUsageSwitch:
			ret = @"Usage Switch";
			break;
			
		default:
			ret = [NSString stringWithFormat:@"Unknown (%lu)", (NSUInteger)type];
			break;
	}
	
	return ret;
}

@dynamic usagePage;
- (NSString *)usagePage
{
	HIDElement *element = self.representedObject;
	return [HXUsageTableTranslator nameForUsagePage:element.usagePage];
}

@dynamic usageID;
- (NSString *)usageID
{
	HIDElement *element = self.representedObject;
	return [HXUsageTableTranslator nameForUsagePage:element.usagePage usageID:element.usage];
}

@dynamic value;
- (NSString *)value
{
	HIDElement *element = self.representedObject;
	
	if (element.byteValue)
	{
		return @"Bytes";
	}
	else
	{
		return element.integerValue;
	}
	
	return nil;
}


@end
