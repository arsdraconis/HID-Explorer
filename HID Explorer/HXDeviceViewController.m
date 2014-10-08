//
//  HXDeviceViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//


#import <HIDKit/HIDKit.h>
#import "ElementTreeNode.h"

#import "HXDeviceViewController.h"
#import "HXElementInspectorViewController.h"

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXDeviceViewController ()

@property (weak) HXElementInspectorViewController *inspectorVC;

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXDeviceViewController

- (void)viewWillAppear
{
	// Set the represented object.
	[self setRepresentedObject:self.parentViewController.representedObject];
	
	// Keep a reference to our inspector view controller.
	NSMutableArray *splitViewItems = [[((NSSplitViewController *)(self.parentViewController)) childViewControllers] mutableCopy];
	[splitViewItems removeObject:self];
	self.inspectorVC = splitViewItems.lastObject;
}

- (void)setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	HIDDevice *device = (HIDDevice *)representedObject;
	
	self.view.window.title = [NSString stringWithFormat:@"%@ device: %@", device.transport, device.product];
	
	self.nameLabel.stringValue = device.product;
	self.manufacturerLabel.stringValue = device.manufacturer;
	self.transportLabel.stringValue = device.transport;
	
	[self buildElementTree:device];
}


//------------------------------------------------------------------------------
#pragma mark UI Functionality
//------------------------------------------------------------------------------

- (IBAction)upateSelection:(id)sender
{
	NSArray *selection = self.elementsTreeController.selectedObjects;
	self.inspectorVC.representedObject = ((ElementTreeNode *)(selection.firstObject)).representedObject;
}


//------------------------------------------------------------------------------
#pragma mark Building the Element Tree
//------------------------------------------------------------------------------
- (void)buildElementTree:(HIDDevice *)device
{
	ElementTreeNode *temp = [ElementTreeNode treeNodeWithRepresentedObject:nil];
	
	for (HIDElement *element in device.elements)
	{
		ElementTreeNode *node = [self builtTreeBranch:element];
		[temp.mutableChildNodes addObject:node];
	}
	
	self.rootNode = temp;
}

- (ElementTreeNode *)builtTreeBranch:(HIDElement *)element
{
	ElementTreeNode *node = [ElementTreeNode treeNodeWithRepresentedObject:element];
	
	NSArray *children = element.children;
	if (children.count != 0)
	{
		for (HIDElement *child in children)
		{
			ElementTreeNode *branch = [self builtTreeBranch:child];
			[node.mutableChildNodes addObject:branch];
		}
	}
	
	return node;
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
