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

@end


//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HXDeviceViewController




//------------------------------------------------------------------------------
#pragma mark View Lifecycle
//------------------------------------------------------------------------------
- (void)viewWillAppear
{
	self.representedObject = self.parentViewController.representedObject;
}


@end
