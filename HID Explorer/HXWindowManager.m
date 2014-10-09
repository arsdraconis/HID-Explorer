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

@property (readonly) NSMutableArray *windowControllers;
@property NSPoint cascadePoint;

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
		_cascadePoint = NSZeroPoint;
	}
	return self;
}


//------------------------------------------------------------------------------
#pragma mark Getting the Window for a Device
//------------------------------------------------------------------------------
- (void)windowForDevice:(HIDDevice *)device
{
	NSWindowController *wc;
	
	for (NSWindowController *windowController in _windowControllers)
	{
		// Look through our windows to see if we have one open for the device.
		HIDDevice *windowDevice = (HIDDevice *)windowController.window.contentViewController.representedObject;
		if (windowDevice == device)
		{
			wc = windowController;
			break;
		}
	}
	
	// Otherwise create a new window for that device.
	if (!wc)
	{
		NSStoryboard *sb = [NSStoryboard storyboardWithName:@"DeviceWindow" bundle:nil];
		wc = [sb instantiateInitialController];
		
		[_windowControllers addObject:wc];
		[self cascadeWindow:wc.window];
		wc.window.delegate = self;
		
		wc.window.title = [NSString stringWithFormat:@"%@ (%@)", device.product, device.transport];
		wc.window.contentViewController.representedObject = device;
		[device open];
	}
	
	[wc showWindow:nil];
}


//------------------------------------------------------------------------------
#pragma mark Cascading Device Windows
//------------------------------------------------------------------------------
- (void)cascadeWindow:(NSWindow *)window
{
	if (self.cascadePoint.x == 0 && self.cascadePoint.y == 0)
	{
		self.cascadePoint = window.frame.origin;
	}
	
	self.cascadePoint = [window cascadeTopLeftFromPoint:self.cascadePoint];
}


//------------------------------------------------------------------------------
#pragma mark Window Delegate Methods
//------------------------------------------------------------------------------
- (void)windowWillClose:(NSNotification *)notification
{
	@autoreleasepool
	{
		for (NSWindowController *wc in _windowControllers)
		{
			if (wc.window == notification.object)
			{
				HIDDevice *device = (HIDDevice *)(wc.window.contentViewController.representedObject);
				[device close];
				[_windowControllers removeObject:wc];
				break;
			}
		}
		
	}
}

@end
