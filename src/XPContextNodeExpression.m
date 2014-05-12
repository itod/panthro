//
//  XPContextNodeExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPContextNodeExpression.h"
#import "XPContext.h"
#import "XPNodeSetValue.h"
#import "XPNodeInfo.h"
#import "XPNodeTypeTest.h"
#import "XPAxis.h"
#import "XPAxisEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPSingletonEnumeration.h"

@implementation XPContextNodeExpression

- (NSString *)description {
    return @"context-node()";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


/**
 * Perform a partial evaluation of the expression, by eliminating specified dependencies
 * on the context.
 * @param dependencies The dependencies to be removed
 * @param context The context to be used for the partial evaluation
 * @return a new expression that does not have any of the specified
 * dependencies
 */

- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (([self dependencies] & XPDependenciesContextNode) != 0) {
        return [[[XPSingletonNodeSet alloc] initWithNode:ctx.contextNode] autorelease];
    } else {
        return self;
    }
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    return [[[XPSingletonEnumeration alloc] initWithNode:ctx.contextNode] autorelease];
//    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
//    id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisSelf nodeTest:nodeTest];
//    XPAssert(enm);
//    return enm;
}


- (BOOL)isContextDocumentNodeSet {
    return YES;
}

@end
