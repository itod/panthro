//
//  XPSequenceExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPBinaryExpression.h"

@interface XPSequenceExpression : XPBinaryExpression

+ (instancetype)sequenceExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;
@end
