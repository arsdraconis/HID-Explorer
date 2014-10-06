//
//  HXWindowManager.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/18/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXWindowManager.h"

@class HIDDevice;

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
		wc.window.contentViewController.representedObject = device;
		[self cascadeWindow:wc.window];
		wc.window.delegate = self;
	}
	
	[wc showWindow:nil];
}

- (void)cascadeWindow:(NSWindow *)window
{
	if (self.cascadePoint.x == 0 && self.cascadePoint.y == 0)
	{
		self.cascadePoint = window.frame.origin;
	}
	
	self.cascadePoint = [window cascadeTopLeftFromPoint:self.cascadePoint];
}

- (void)windowWillClose:(NSNotification *)notification
{
	@autoreleasepool
	{
		for (NSWindowController *wc in _windowControllers)
		{
			if (wc.window == notification.object)
			{
				[_windowControllers removeObject:wc];
				break;
			}
		}
		
	}
}

@end
