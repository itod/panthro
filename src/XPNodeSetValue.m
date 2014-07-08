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

- (id <XPNodeInfo>)firstNode {
    id <XPItem>item = [self head];
    if (![item conformsToProtocol:@protocol(XPNodeInfo)]) {
        [XPException raiseIn:self format:@"Expected node value, found: %@", item];
    }
    return (id <XPNodeInfo>)item;
}

@end
