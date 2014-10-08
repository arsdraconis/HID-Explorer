//
//  HXElementInspectorViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXElementInspectorViewController.h"

#import "HXDeviceViewController.h"

static const NSString *HXSelectedElementKey = @"HXSelectedElementKey";



@interface HXElementInspectorViewController ()

@property (weak) HXDeviceViewController *deviceVC;
@property BOOL isCurrentlyObserving;

@end



@implementation HXElementInspectorViewController

- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	NSLog(@"Inspecting %@", representedObject);
	// TODO: set represented object here.
}



@end
