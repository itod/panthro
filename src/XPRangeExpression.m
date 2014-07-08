//
//  XPRangeExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPRangeExpression.h"
#import "XPAtomicSequence.h"
#import "XPNumericValue.h"

@implementation XPRangeExpression

+ (instancetype)rangeExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}

//    A range expression can be used to construct a sequence of consecutive integers.
//    Each of the operands of the to operator is converted as though it was an argument of a function with the expected parameter type xs:integer?.
//
//    If either operand is an empty sequence, or if the integer derived from the first operand is greater than the integer derived from
//    the second operand, the result of the range expression is an empty sequence.
//
//    If the two operands convert to the same integer, the result of the range expression is that integer.
//
//    Otherwise, the result is a sequence containing the two integer operands and every integer between the two operands, in increasing order.

- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsNodeSetInContext:ctx];
}


- (XPSequenceValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    NSMutableArray *v = [NSMutableArray array];
    
    double d1 = [self.p1 evaluateAsNumberInContext:ctx];
    double d2 = [self.p2 evaluateAsNumberInContext:ctx];
    
    if (d1 > d2) {
        // produce empty seq
    }
    
    else if (d1 == d2) {
        [v addObject:[XPNumericValue numericValueWithNumber:d2]];
    }
    
    else {
        for (NSInteger i = d1; i <= d2; ++i) {
            [v addObject:[XPNumericValue numericValueWithNumber:i]];
        }
    }
    
    XPSequenceValue *seq = [[[XPAtomicSequence alloc] initWithContent:v] autorelease];
    return seq;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
