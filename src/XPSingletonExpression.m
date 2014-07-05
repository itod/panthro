//
//  XPSingletonExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSingletonExpression.h"
#import "XPSingletonEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPNodeInfo.h"

@implementation XPSingletonExpression

- (BOOL)isContextDocumentNodeSet {
    return YES;
}

/**
 * Get the single node to which this expression refers
 */

- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


/**
 * Return the first node selected by this Expression when evaluated in the current context
 * @param context The context for the evaluation
 * @return the NodeInfo of the first node in document order, or null if the node-set
 * is empty.
 */

- (id <XPItem>)selectFirstInContext:(XPContext *)ctx {
    return [self nodeInContext:ctx];
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
        result = [[[XPSingletonNodeSet alloc] initWithNode:[self nodeInContext:ctx]] autorelease];
        result.range = self.range;
    }
    
    return result;
}

/**
 * Evaluate the expression in a given context to return a Node enumeration
 * @param context the evaluation context
 * @param sort Indicates result must be in document order
 */

- (id<XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    return [[[XPSingletonEnumeration alloc] initWithItem:[self nodeInContext:ctx]] autorelease];
}


/**
 * Evaluate an expression as a NodeSet.
 * @param context The context in which the expression is to be evaluated
 * @return the value of the expression, evaluated in the current context
 */

- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    return [[[XPSingletonNodeSet alloc] initWithNode:[self nodeInContext:ctx]] autorelease];
}


/**
 * Evaluate as a string. Returns the string value of the node if it exists
 * @param context The context in which the expression is to be evaluated
 * @return true if there are any nodes selected by the NodeSetExpression
 */

- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    id <XPItem>node = [self nodeInContext:ctx];
    if (!node) return @"";
    return [node stringValue];
}


/**
 * Evaluate as a boolean. Returns true if there are any nodes
 * selected by the NodeSetExpression
 * @param context The context in which the expression is to be evaluated
 * @return true if there are any nodes selected by the NodeSetExpression
 */

- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    return [self nodeInContext:ctx] != nil;
}

@end
