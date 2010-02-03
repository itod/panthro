//
//  XPRelationalExpression.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPBinaryExpression.h>

@interface XPRelationalExpression : XPBinaryExpression {

}

+ (id)relationalExpression;

+ (id)relationalExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
