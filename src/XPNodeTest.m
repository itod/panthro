//
//  XPNodeTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNodeTest.h"
#import "XPNodeInfo.h"

@implementation XPNodeTest

- (BOOL)matches:(id <XPNodeInfo>)node {
    return [self matches:node.nodeType name:node.name];
}


- (BOOL)matches:(XPNodeType)nodeType name:(NSString *)nodeName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)matches:(id <XPNodeInfo>)node inContext:(XPContext *)ctx {
    return [self matches:node];
}

@end
