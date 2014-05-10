//
//  XPDoubleComparer.m
//  XPath
//
//  Created by Todd Ditchendorf on 9/12/11.
//  Copyright 2011 Celestial Teapot. All rights reserved.
//

#import "XPDoubleComparer.h"
#import "XPValue.h"

@implementation XPDoubleComparer

- (NSComparisonResult)compare:(id)a to:(id)b {
    double a1 = XPNumberFromString((NSString *)a);
    double b1 = XPNumberFromString((NSString *)b);
    if (isnan(a1)) {
        if (isnan(b1)) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }
    if (isnan(b1)) {
        return NSOrderedDescending;
    }
    if (a1 == b1) return NSOrderedSame;
    if (a1 < b1) return NSOrderedAscending;
    return NSOrderedDescending;
}

@end
