//
//  HXDeviceViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "HXDeviceViewController.h"


//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXDeviceViewController ()

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXDeviceViewController

- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	HIDDevice *device = (HIDDevice *)representedObject;
	
	self.view.window.title = [NSString stringWithFormat:@"%@ device: %@", device.transport, device.product];
	
	self.nameLabel.stringValue = device.product;
	self.manufacturerLabel.stringValue = device.manufacturer;
	self.transportLabel.stringValue = device.transport;
}

- (IBAction)setShouldLiveUpdate:(id)sender
{
	NSButton *checkBox = (NSButton *)sender;
	if (checkBox.state == NSOnState)
	{
		NSLog(@"Will allow live updating.");
	}
	else
	{
		NSLog(@"Will not allow live updating.");
	}
}

//------------------------------------------------------------------------------
#pragma mark View Lifecycle
//------------------------------------------------------------------------------
- (void)viewDidAppear
{
	HIDDevice *device = self.representedObject;
	[device open];
}

- (void)viewDidDisappear
{
	HIDDevice *device = self.representedObject;
	[device close];
}


@end
