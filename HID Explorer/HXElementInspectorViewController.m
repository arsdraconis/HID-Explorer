//
//  HXElementInspectorViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXElementInspectorViewController.h"

#import "HXDeviceViewController.h"


//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXElementInspectorViewController ()


@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXElementInspectorViewController

- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	NSLog(@"Inspecting %@", representedObject);
	// TODO: set represented object here.
}

- (IBAction)setLiveUpdate:(id)sender
{
	NSButton *checkBox = (NSButton *)sender;
	if (checkBox.state == NSOnState)
	{
		NSLog(@"Live updating on.");
	}
	else
	{
		NSLog(@"Live updating off.");
	}
}

@end
