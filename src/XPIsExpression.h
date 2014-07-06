//
//  XPIsExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"

@interface XPIsExpression : XPBinaryExpression

+ (instancetype)isExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;
@end
