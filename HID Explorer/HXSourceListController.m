//
//  HXSourceListController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/14/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXSourceListController.h"
#import "HXSourceListItem.h"
#import <HIDKit/HIDKit.h>

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXSourceListController ()

@property IBOutlet NSTreeController *sidebarTreeController;
@property NSMutableArray *sourceListItems;
@property IBOutlet NSOutlineView *sourceList;

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXSourceListController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.sourceListItems = [NSMutableArray array];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidConnect:)
												 name:HIDManagerDeviceDidConnectNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidDisconnect:)
												 name:HIDManagerDeviceDidDisconnectNotification
											   object:nil];
	
	[self.parentViewController bind:@"representedObject"
						   toObject:self.sidebarTreeController
						withKeyPath:@"selectedObjects.device"
							options:nil];
	
	[HIDManager sharedManager];
}

- (void)viewWillAppear
{
	[self refreshDevices:self];
}

- (void)dealloc
{
	[self.parentViewController unbind:@"representedObject"];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:HIDManagerDeviceDidConnectNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:HIDManagerDeviceDidDisconnectNotification
												  object:nil];
}

//------------------------------------------------------------------------------
#pragma mark Adding and Removing Devices
//------------------------------------------------------------------------------
- (IBAction)refreshDevices:(id)sender
{
	NSMutableArray *listItems = [self mutableArrayValueForKey:@"sourceListItems"];
	[listItems removeAllObjects];
	
	NSArray *devices = [HIDManager devices];
	for (HIDDevice *device in devices)
	{
		[HXSourceListItem insertDevice:device intoTree:listItems];
	}
	
	// Using GCD to queue this at the end of the current run loop iteration.
	dispatch_async(dispatch_get_main_queue(),
	^{
		[self.sourceList expandItem:nil expandChildren:YES];
		[self.sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:1]
					 byExtendingSelection:NO];
	});
}

- (void)deviceDidConnect:(NSNotification *)note
{
	NSLog(@"[HID Explorer] Device connected.");
	
	NSMutableArray *listItems = [self mutableArrayValueForKey:@"sourceListItems"];
	id item = [HXSourceListItem insertDevice:note.object intoTree:listItems];
	[self expandGroupItem:item];
}

- (void)deviceDidDisconnect:(NSNotification *)note
{
	NSLog(@"[HID Explorer] Device disconnected.");
	
	NSMutableArray *listItems = [self mutableArrayValueForKey:@"sourceListItems"];
	@autoreleasepool
	{
		[HXSourceListItem removeNodeWithDevice:note.object inTree:listItems];
	}
}


//------------------------------------------------------------------------------
#pragma mark Outline View Delegate Methods
//------------------------------------------------------------------------------
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	HXSourceListItem *node = (HXSourceListItem *)item;
	if (!node.isLeaf)
	{
		return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
	}
	else
	{
		return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	HXSourceListItem *node = (HXSourceListItem *)item;
	return !node.isLeaf;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	HXSourceListItem *node = (HXSourceListItem *)item;
	return node.isLeaf;
}

- (void)expandGroupItem:(HXSourceListItem *)item
{
	// Using GCD to queue it at the end of the current run loop iteration.
	dispatch_async(dispatch_get_main_queue(),
	^{
		[self.sourceList expandItem:item expandChildren:YES];
	});
}


@end
