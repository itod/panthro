//
//  XPIsExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPIsExpression.h"
#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPEGParser.h"

@implementation XPIsExpression

+ (instancetype)isExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ is %@", self.p1, self.p2];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    XPValue *s1 = [self.p1 evaluateInContext:ctx];
    XPValue *s2 = [self.p2 evaluateInContext:ctx];
    
    return [s1 compareToValue:s2 usingOperator:self.operator];
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
