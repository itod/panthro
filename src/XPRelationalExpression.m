//
//  XPRelationalExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPRelationalExpression.h"
#import "XPValue.h"
#import "XPBooleanValue.h"

@implementation XPRelationalExpression

+ (XPRelationalExpression *)relationalExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPRelationalExpression *)relationalExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (NSString *)description {
    NSString *opStr = nil;
    switch (self.operator) {
        case XPTokenTypeEquals:
            opStr = @"=";
            break;
        case XPTokenTypeNE:
            opStr = @"!=";
            break;
        case XPTokenTypeLT:
            opStr = @"<";
            break;
        case XPTokenTypeGT:
            opStr = @">";
            break;
        case XPTokenTypeLE:
            opStr = @"<=";
            break;
        case XPTokenTypeGE:
            opStr = @">=";
            break;
        default:
            XPAssert(0);
            break;
    }
    return [NSString stringWithFormat:@"%@ %@ %@", self.p1, opStr, self.p2];
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    
    // TODO
    
    if ([self.p1 isValue] && [self.p2 isValue]) {
        result = [self evaluateInContext:nil];
    }
    
    // TODO
    
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
    XPValue *s1 = [self.p1 evaluateInContext:ctx];
    XPValue *s2 = [self.p2 evaluateInContext:ctx];
    
    return [s1 compareToValue:s2 usingOperator:self.operator];
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
