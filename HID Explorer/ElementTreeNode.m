//
//  ElementTreeNode.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <HIDKit/HIDKit.h>

#import "ElementTreeNode.h"


@implementation ElementTreeNode

@dynamic name;
- (NSString *)name
{
	HIDElement *element = (HIDElement *)self.representedObject;
	return element.name;
}

@dynamic type;
- (NSString *)type
{
	HIDElement *element = (HIDElement *)self.representedObject;
	IOHIDElementType type = element.type;
	
	NSString *ret;
	
	switch (type)
	{
		case kIOHIDElementTypeInput_Misc:
			ret = @"Misc.";
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
			ret = @"Collection";
			break;
			
		default:
			ret = @"Unknown";
			break;
	}
	
	return ret;
}

@dynamic cookie;
- (NSUInteger)cookie
{
	HIDElement *element = (HIDElement *)self.representedObject;
	return (NSUInteger)element.cookie;
}

@end
