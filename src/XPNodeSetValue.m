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

@end
