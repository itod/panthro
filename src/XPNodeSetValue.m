//
//  XPNodeSetValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/8/14.
//
//

#import "XPNodeSetValue.h"
#import "XPException.h"

@implementation XPNodeSetValue

- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    if (yn) [self sort];
    return [self enumerate];
}


- (id <XPNodeInfo>)firstNode {
    id <XPItem>item = [self head];
    if (![item conformsToProtocol:@protocol(XPNodeInfo)]) {
        [XPException raiseIn:self format:@"Expected node value, found: %@", item];
    }
    return (id <XPNodeInfo>)item;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (BOOL)isSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (void)setSorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (BOOL)isReverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (void)setReverseSorted:(BOOL)reverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (XPNodeSetValue *)sort {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return self;
}

@end
