//
//  HXWindowManager.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/18/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HIDDevice;

@interface HXWindowManager : NSObject

- (void)windowForDevice:(HIDDevice *)device;

@end
