//
//  XPBinaryExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPBinaryExpression : XPExpression

- (instancetype)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end
