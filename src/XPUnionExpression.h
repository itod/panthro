//
//  XPUnionExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import <XPath/XPath.h>

@interface XPUnionExpression : XPNodeSetExpression

- (instancetype)initWithLhs:(XPExpression *)lhs rhs:(XPExpression *)rhs;
@end
