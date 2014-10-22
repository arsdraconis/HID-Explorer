//
//  HXElementInspectorViewController.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HXElementInspectorViewController.h"

#import "ElementTreeNode.h"
#import <HIDKit/HIDKit.h>
#import "HXUsageTableTranslator.h"

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXElementInspectorViewController ()

@property IBOutlet NSOutlineView *elementsOutlineView;
@property IBOutlet NSTreeController *elementsTreeController;
@property ElementTreeNode *rootNode;

@property IBOutlet NSButton *liveUpdateCheckbox;

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXElementInspectorViewController

//------------------------------------------------------------------------------
#pragma mark View Lifecycle
//------------------------------------------------------------------------------

- (void)viewDidLoad
{
	[self bind:@"representedObject"
	  toObject:self.parentViewController.parentViewController
   withKeyPath:@"representedObject"
	   options:nil];
}

- (void)dealloc
{
	[self unbind:@"representedObject"];
}

//------------------------------------------------------------------------------
#pragma mark Building the Element Tree
//------------------------------------------------------------------------------
- (void)setRepresentedObject:(id)representedObject
{
	HIDDevice *device = representedObject;
	
	[super setRepresentedObject:device];
	
	if (device)
	{
		[self buildElementTree:device];
		[self setLiveUpdate:self];
	}
}

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
#pragma mark UI Actions
//------------------------------------------------------------------------------
- (IBAction)setLiveUpdate:(id)sender
{
	BOOL shouldLiveUpdate = (BOOL)self.liveUpdateCheckbox.state;
	
	HIDDevice *device = self.representedObject;
	if (shouldLiveUpdate)
	{
		[device open];
	}
	else
	{
		[device close];
	}
}


//------------------------------------------------------------------------------
#pragma mark Outline View Delegate Methods
//------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	NSArray *selectedObjects = self.elementsTreeController.selectedObjects;
	ElementTreeNode *node = [selectedObjects lastObject];
	
	self.selectedElement = node.representedObject;
}


@end
