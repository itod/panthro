//
//  XPNodeSetExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPExpression.h>

@class XPNodeEnumerator;

@interface XPNodeSetExpression : XPExpression

- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted;

@end
