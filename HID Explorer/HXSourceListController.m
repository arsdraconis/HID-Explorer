//
//  HXSourceListController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/14/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


// FIXME: We can seriously refactor the source list methods into something else,
// perhaps a category, to clean this up.

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
	
	self.sidebarTreeController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidConnect:)
												 name:HIDManagerDeviceDidConnectNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceDidDisconnect:)
												 name:HIDManagerDeviceDidDisconnectNotification
											   object:nil];
	
	[HIDManager sharedManager];
	
	// Expand our source list and select a valid item.
	[self expandGroupItem:nil];
	[self selectAdjacentItem];
}

- (void)dealloc
{
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
	
//	[HXSourceListItem sortTree:listItems];
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
	HXSourceListItem *node = item;
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
	HXSourceListItem *node = item;
	return !node.isLeaf;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	HXSourceListItem *node = item;
	return node.isLeaf;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	HXSourceListItem *selection = [self.sidebarTreeController.selectedObjects lastObject];
	self.parentViewController.representedObject = selection.device;
}


//------------------------------------------------------------------------------
#pragma mark Outline View Control
//------------------------------------------------------------------------------
- (void)expandGroupItem:(HXSourceListItem *)item
{
	// Using GCD to queue it at the end of the current run loop iteration.
	dispatch_async(dispatch_get_main_queue(),
	^{
		[self.sourceList expandItem:item expandChildren:YES];
	});
}

- (void)selectAdjacentItem
{
	// FIXME: Implement this.
	// This only selects the first item in the list for now. What it SHOULD do
	// is select the item adjent to the one that was previously selected, and
	// default to the first item if nothing was selected.
	dispatch_async(dispatch_get_main_queue(),
	^{
		[self.sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:1]
					 byExtendingSelection:NO];
	});

}


@end
