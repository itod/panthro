//
//  XPArithmeticExpression.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPBinaryExpression.h>

@interface XPArithmeticExpression : XPBinaryExpression {
    
}

+ (id)arithmeticExpression;

+ (id)arithmeticExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
