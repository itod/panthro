//
//  XPArithmeticExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPArithmeticExpression.h"
#import "XPValue.h"
#import "XPNumericValue.h"
#import "XPException.h"
#import "XPEGParser.h"

@implementation XPArithmeticExpression

+ (XPArithmeticExpression *)arithmeticExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPArithmeticExpression *)arithmeticExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    XPValue *val = [XPNumericValue numericValueWithNumber:n];
    val.range = self.range;
    return val;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    double n1 = [self.p1 evaluateAsNumberInContext:ctx];
    double n2 = [self.p2 evaluateAsNumberInContext:ctx];

    switch (self.operator) {
        case XPEG_TOKEN_KIND_PLUS:
            return n1 + n2;
        case XPEG_TOKEN_KIND_MINUS:
            return n1 - n2;
        case XPEG_TOKEN_KIND_MULTIPLYOPERATOR:
            return n1 * n2;
        case XPEG_TOKEN_KIND_DIV:
            return n1 / n2;
        case XPEG_TOKEN_KIND_MOD:
            return lrint(n1) % lrint(n2);
//        case XPEG_TOKEN_KIND_MINUS:
//            return -n2;
        default:
            [XPException raiseIn:self format:@"invalid operator in arithmetic expr"];
            return NAN;
            break;
    }
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}

@end
