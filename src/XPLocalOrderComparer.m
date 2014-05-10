//
//  XPLocalOrderComparer.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/5/14.
//
//

#import "XPLocalOrderComparer.h"
#import "XPNodeInfo.h"

@implementation XPLocalOrderComparer
/**
 * Get an instance of a LocalOrderComparer. The class maintains no state
 * so this returns the same instance every time.
 */

+ (instancetype)instance {
    static XPLocalOrderComparer *sInstance = nil;
    if (!sInstance) {
        sInstance = [[XPLocalOrderComparer alloc] init];
    }
    return sInstance;
}


- (NSComparisonResult)compare:(id <XPNodeInfo>)a to:(id <XPNodeInfo>)b {
    return [a compareOrderTo:b];
}

@end
