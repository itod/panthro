//
//  XPBinaryExpression.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPExpression.h>

@interface XPBinaryExpression : XPExpression {
    XPExpression *p1;
    XPExpression *p2;
    NSInteger operator;
}

+ (id)binaryExpression;

+ (id)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

- (id)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
