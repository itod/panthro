//
//  XPParentNodeExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPParentNodeExpression.h"
#import "XPNodeInfo.h"
#import "XPContext.h"

@implementation XPParentNodeExpression

- (NSString *)description {
    return @"parent-node()";
}


/**
 * Return the node selected by this SingletonExpression
 * @param context The context for the evaluation
 * @return the parent of the current node defined by the context
 */

- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx {
    return ctx.contextNode.parent;
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}

@end
