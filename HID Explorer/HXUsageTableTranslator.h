//
//  HXUsageTableTranslator.h
//  HID Explorer
//
//  Created by Robert Luis Hoover on 10/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXUsageTableTranslator : NSObject

+ (NSString *)nameForUsagePage:(NSUInteger)usagePage;
+ (NSString *)nameForUsagePage:(NSUInteger)usagePage usageID:(NSUInteger)usageID;

@end
