//
//  XPNodeSetExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@protocol XPNodeEnumeration;

@interface XPNodeSetExpression : XPExpression

/**
 * Return a node enumeration. All NodeSetExpressions must implement this method:
 * the evaluate() function is defined in terms of it. (But note that some expressions
 * that return node-sets are not NodeSetExpressions: for example functions such as
 * key(), id(), and document() are not, and neither are variable references).
 * @param context The evaluation context
 * @param sorted True if the nodes must be returned in document order
 */

- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

@end
