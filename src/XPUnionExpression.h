//
//  XPUnionExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPNodeSetExpression.h"

@interface XPUnionExpression : XPNodeSetExpression

- (instancetype)initWithLhs:(XPExpression *)lhs rhs:(XPExpression *)rhs;

- (NSString *)operator;
- (Class)enumerationClass;
@end
