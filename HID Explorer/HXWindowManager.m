//
//  HXWindowManager.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/18/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXWindowManager.h"

#import <HIDKit/HIDKit.h>

//------------------------------------------------------------------------------
#pragma mark Class Extension
//------------------------------------------------------------------------------
@interface HXWindowManager ()

@property NSMutableArray *windowControllers;

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXWindowManager

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_windowControllers = [NSMutableArray array];
	}
	return self;
}

- (void)windowForDevice:(HIDDevice *)device
{
	NSWindowController *wc;
	
	for (NSWindowController *windowController in _windowControllers)
	{
		// Look through our windows to see if we have one open for the device.
	}
	
	// Otherwise create a new window for that device.
	if (!wc)
	{
		NSStoryboard *sb = [NSStoryboard storyboardWithName:@"DeviceWindow" bundle:nil];
		wc = [sb instantiateInitialController];
		[_windowControllers addObject:wc];
		[wc.window setTitle:device.product];
	}
	
	[wc showWindow:nil];
}

@end
