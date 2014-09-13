//
//  HXDevicesViewController.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HXDevicesViewController : NSViewController

@property IBOutlet NSArrayController *devicesArrayController;
@property NSMutableArray *devices;
@property IBOutlet NSTableView *table;

- (IBAction)refreshDevices:(id)sender;
- (void)tableWasDoubleClicked;

@end
