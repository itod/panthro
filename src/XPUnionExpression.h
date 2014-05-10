//
//  XPUnionExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "Panthro.h"

@interface XPUnionExpression : XPNodeSetExpression

- (instancetype)initWithLhs:(XPExpression *)lhs rhs:(XPExpression *)rhs;
@end
