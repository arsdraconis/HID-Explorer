//
//  HXDeviceViewController.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/17/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HXDeviceViewController : NSViewController

@property IBOutlet NSArrayController *usagePairsArrayController;
@property NSMutableArray *usagePairs;

@end
