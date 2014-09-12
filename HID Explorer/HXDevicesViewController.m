//
//  HXDevicesViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "HXDevicesViewController.h"


//------------------------------------------------------------------------------
#pragma mark Class Extension
//------------------------------------------------------------------------------
@interface HXDevicesViewController ()

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXDevicesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear
{
	[self refreshDevices];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshDevices)
												 name:HIDManagerDeviceDidConnectNotification
											   object:[HIDManager sharedManager]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshDevices)
												 name:HIDManagerDeviceDidDisconnectNotification
											   object:[HIDManager sharedManager]];
}

- (void)viewDidDisappear
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
	
	// Update the view, if already loaded.
	
}

- (void)refreshDevices
{
	[self.devicesArrayController setContent:[HIDManager devices]];
}

@end
