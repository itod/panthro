//
//  XPRootExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPRootExpression.h"
#import "XPDocumentInfo.h"
#import "XPNodeInfo.h"
#import "XPContext.h"

@implementation XPRootExpression

- (NSString *)description {
    return @"root()";
}


/**
 * Return the first element selected by this Expression
 * @param context The evaluation context
 * @return the NodeInfo of the first selected element, or null if no element
 * is selected
 */

- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx {
    return ctx.contextNode.documentRoot;
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    return XPDependenciesContextNode | XPDependenciesContextDocument;
}

@end
