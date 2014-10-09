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

//------------------------------------------------------------------------------
#pragma mark Split View Delegate Methods
//------------------------------------------------------------------------------

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	return YES;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
	if (proposedMinimumPosition < 100)
	{
		return 100;
	}
	else
	{
		return proposedMinimumPosition;
	}
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
	CGFloat limit = splitView.bounds.size.height - 100;
	if (proposedMaximumPosition > limit)
	{
		return limit;
	}
	else
	{
		return proposedMaximumPosition;
	}
}

@end
