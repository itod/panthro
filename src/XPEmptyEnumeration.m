//
//  XPEmptyEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPEmptyEnumeration.h"

@implementation XPEmptyEnumeration

+ (instancetype)instance {
    static XPEmptyEnumeration *sInstance = nil;
    if (!sInstance) {
        sInstance = [[XPEmptyEnumeration alloc] init];
    }
    return sInstance;
}


#pragma mark -
#pragma mark XPPauseHandler

- (NSArray *)currentResultNodes {
    return [NSArray array];
}


- (BOOL)isSorted {
    return YES;
}


- (BOOL)isReverseSorted {
    return YES;
}


- (BOOL)isPeer {
    return YES;
}


- (BOOL)hasMoreItems {
    return NO;
}


- (id <XPItem>)nextItem {
    return nil;
}


- (NSUInteger)lastPosition {
    return 0;
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    return 0;
}

@end
