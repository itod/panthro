//
//  XPNodeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPNodeTest.h"
#import "XPNodeInfo.h"

@implementation XPNodeTest

- (BOOL)matches:(id <XPNodeInfo>)node {
    return [self matches:node.nodeType namespaceURI:node.namespaceURI localName:node.localName];
}


- (BOOL)matches:(XPNodeType)nodeType namespaceURI:(NSString *)nsURI localName:(NSString *)localName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)matches:(id <XPNodeInfo>)node inContext:(XPContext *)ctx {
    return [self matches:node];
}

@end
