//
//  XPRelationalExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPRelationalExpression.h>
#import <XPath/XPValue.h>
#import <XPath/XPBooleanValue.h>

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
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    
    // TODO
    
    if ([self.p1 isValue] && [self.p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    // TODO
    return self;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    return [XPBooleanValue booleanValueWithBoolean:b];
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
