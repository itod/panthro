//
//  XPSequenceExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSequenceExpression.h"

@implementation XPSequenceExpression

+ (instancetype)sequenceExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    
    // TODO
    
    //result.range = self.range;
    return result;
}

@end
