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
#import "XPEGParser.h"

@implementation XPRelationalExpression

+ (XPRelationalExpression *)relationalExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (NSString *)description {
    NSString *opStr = nil;
    switch (self.operator) {
        case XPEG_TOKEN_KIND_EQUALS:
            opStr = @"=";
            break;
        case XPEG_TOKEN_KIND_NOT_EQUAL:
            opStr = @"!=";
            break;
        case XPEG_TOKEN_KIND_LT_SYM:
            opStr = @"<";
            break;
        case XPEG_TOKEN_KIND_GT_SYM:
            opStr = @">";
            break;
        case XPEG_TOKEN_KIND_LE_SYM:
            opStr = @"<=";
            break;
        case XPEG_TOKEN_KIND_GE_SYM:
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
