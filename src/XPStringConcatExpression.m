//
//  XPStringConcatExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPStringConcatExpression.h"
#import "XPValue.h"
#import "XPStringValue.h"

@implementation XPStringConcatExpression

+ (XPStringConcatExpression *)stringConcatExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];

    if ([self.p2 isValue] && [self.p2 isValue]) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *s = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:s];
    val.range = self.range;
    return val;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s1 = [self.p1 evaluateAsStringInContext:ctx];
    NSString *s2 = [self.p2 evaluateAsStringInContext:ctx];
    
    NSString *result = [NSString stringWithFormat:@"%@%@", s1, s2];
    return result;
}


- (XPDataType)dataType {
    return XPDataTypeString;
}

@end
