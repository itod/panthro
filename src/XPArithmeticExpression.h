//
//  XPArithmeticExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"

@interface XPArithmeticExpression : XPBinaryExpression
+ (instancetype)arithmeticExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;
@end
