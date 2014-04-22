//
//  XPArithmeticExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPBinaryExpression.h>

@interface XPArithmeticExpression : XPBinaryExpression

+ (XPArithmeticExpression *)arithmeticExpression;

+ (XPArithmeticExpression *)arithmeticExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
