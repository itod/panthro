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

- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;

    if ((self.dependencies & dep) != 0) {
        result = [[[XPSingletonNodeSet alloc] initWithNode:ctx.contextNode] autorelease];
        result.range = self.range;
    }

    return result;
}


- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx {
    return ctx.contextNode;
}

@end
