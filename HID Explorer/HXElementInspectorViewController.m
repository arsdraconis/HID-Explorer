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

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HXElementInspectorViewController ()


@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXElementInspectorViewController

//------------------------------------------------------------------------------
#pragma mark View Lifecycle
//------------------------------------------------------------------------------
- (void)viewWillAppear
{
	HIDDevice *device = (HIDDevice *)(self.parentViewController.representedObject);
	self.representedObject = device;
	
	[self buildElementTree:device];
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
#pragma mark UI Actions
//------------------------------------------------------------------------------
- (IBAction)setLiveUpdate:(id)sender
{
	NSButton *checkBox = (NSButton *)sender;
	if (checkBox.state == NSOnState)
	{
		NSLog(@"Live updating on.");
	}
	else
	{
		NSLog(@"Live updating off.");
	}
}


@end
