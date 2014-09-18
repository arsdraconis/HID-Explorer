//
//  AppDelegate.m
//  HID Explorer
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "AppDelegate.h"

#import "HXWindowManager.h"

@interface AppDelegate ()

@end


@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	self.windowManager = [[HXWindowManager alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
