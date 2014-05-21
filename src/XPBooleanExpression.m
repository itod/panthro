//
//  XPBooleanExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanExpression.h"
#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPPositionRange.h"

@implementation XPBooleanExpression

+ (XPBooleanExpression *)booleanExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBooleanExpression *)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];

    if ([self.p2 isValue] && [self.p2 isValue]) {
        result = [self evaluateInContext:nil];
    } else if ([self.p1 isKindOfClass:[XPPositionRange class]] && [self.p2 isKindOfClass:[XPPositionRange class]]) {
        XPPositionRange *pr1 = (XPPositionRange *)self.p1;
        XPPositionRange *pr2 = (XPPositionRange *)self.p2;
        if (pr1.maxPosition == NSUIntegerMax && pr2.minPosition == 1) {
            result = [[[XPPositionRange alloc] initWithMin:pr1.minPosition max:pr2.maxPosition] autorelease];
        } else if (pr2.maxPosition == NSUIntegerMax && pr1.minPosition == 1) {
            result = [[[XPPositionRange alloc] initWithMin:pr2.minPosition max:pr1.maxPosition] autorelease];
        }
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    BOOL b1 = [self.p1 evaluateAsBooleanInContext:ctx];
    BOOL b2 = [self.p2 evaluateAsBooleanInContext:ctx];
    
    BOOL result = NO;
    switch (self.operator) {
        case XPTokenTypeAnd:
            result = b1 && b2;
            break;
        case XPTokenTypeOr:
            result = b1 || b2;
            break;
        default:
            XPAssert(0);
            break;
    }

    return result;
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
