//
//  HXDevicesViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "AppDelegate.h"
#import "HXDevicesViewController.h"
#import "HXWindowManager.h"


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
	
	self.devices = [NSMutableArray array];
	[HIDManager sharedManager];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidConnect:)
												 name:HIDManagerDeviceDidConnectNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidDisconnect:)
												 name:HIDManagerDeviceDidDisconnectNotification
											   object:nil];
}

- (void)viewWillAppear
{
	[self refreshDevices:self];
}

- (void)viewDidDisappear
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:HIDManagerDeviceDidConnectNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:HIDManagerDeviceDidDisconnectNotification
												  object:nil];
}

- (IBAction)refreshDevices:(id)sender
{
	NSLog(@"Refreshing devices...");
	[self.devicesArrayController setContent:[HIDManager devices]];
}

- (void)deviceDidConnect:(NSNotification *)note
{
	NSLog(@"Adding a device to table...");
	[self.devicesArrayController addObject:note.object];
}

- (void)deviceDidDisconnect:(NSNotification *)note
{
	NSLog(@"Removing a device from the table...");
	@autoreleasepool {
		[self.devicesArrayController removeObject:note.object];
	}
}

- (void)tableWasDoubleClicked
{
	NSInteger row = self.table.selectedRow;
	if (row > -1)
	{
		HIDDevice *selectedDevice = self.devicesArrayController.arrangedObjects[row];
		AppDelegate *delegate = ((NSApplication *)NSApp).delegate;
		[delegate.windowManager windowForDevice:selectedDevice];
	}
}

@end
