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
#import "XPNodeSetValue.h"
#import "XPLocalOrderComparer.h"
#import "XPNodeTypeTest.h"
#import "XPAxis.h"
#import "XPAxisEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPSingletonEnumeration.h"

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
 * Evaluate as a boolean.
 * @param context The context (not used)
 * @return true (always - because the nodeset is never empty)
 */

- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return YES;
}


/**
 * Evaluate as a string
 * @param context The context for evaluation
 * @return The concatenation of all the character data within the document
 */

- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    return [ctx.contextNode.documentRoot stringValue];
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    return XPDependenciesContextNode | XPDependenciesContextDocument;
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

    if (([self dependencies] & (XPDependenciesContextNode | XPDependenciesContextDocument)) != 0) {
        result = [[[XPSingletonNodeSet alloc] initWithNode:ctx.contextNode.documentRoot] autorelease];
        result.range = self.range;
    }
    
    return result;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    return [[[XPSingletonEnumeration alloc] initWithNode:ctx.contextNode.documentRoot] autorelease];
//    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
//    id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisSelf nodeTest:nodeTest];
//    XPAssert(enm);
//    return enm;
}


- (BOOL)isContextDocumentNodeSet {
    return YES;
}

@end
