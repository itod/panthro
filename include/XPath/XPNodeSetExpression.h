//
//  XPNodeSetExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPExpression.h>

@protocol XPNodeEnumeration;

@interface XPNodeSetExpression : XPExpression

- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

@end
