//
//  XPSequenceExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSequenceExpression.h"
#import "XPAtomicSequence.h"

@implementation XPSequenceExpression

+ (instancetype)sequenceExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


//- (XPExpression *)simplify {
//    self.p1 = [self.p1 simplify];
//    self.p2 = [self.p2 simplify];
//    
//    XPAssert([self.p1 isValue]);
//    XPAssert([self.p2 isValue]);
//    
//    NSArray *v = @[self.p1, self.p2];
//    XPExpression *seq = [[[XPAtomicSequence alloc] initWithContent:v] autorelease];
//    
//    seq.range = self.range;
//    return seq;
//}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSArray *v = @[self.p1, self.p2];
    XPValue *seq = [[[XPAtomicSequence alloc] initWithContent:v] autorelease];
    return seq;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    XPAssert(0);
    return 0.0;
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}

@end
