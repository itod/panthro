//
//  XPBooleanValueTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanValueTest.h"

@implementation XPBooleanValueTest

- (void)setUp {
    b1 = [XPBooleanValue booleanValueWithBoolean:YES];
    b2 = [XPBooleanValue booleanValueWithBoolean:YES];
    b3 = [XPBooleanValue booleanValueWithBoolean:NO];
    b4 = [XPBooleanValue booleanValueWithBoolean:NO];
}


- (void)testAsString {
    TDEqualObjects([b1 asString], @"true");
    TDEqualObjects([b3 asString], @"false");
}


- (void)testAsNumber {
    TDEquals([b1 asNumber], 1.0);
    TDEquals([b3 asNumber], 0.0);
}


- (void)testIsEqualToBoolean {
    TDTrue( [b1 isEqualToValue:b2]);
    TDTrue(![b1 isEqualToValue:b3]);
    TDTrue( [b2 isEqualToValue:b1]);
    TDTrue(![b2 isEqualToValue:b3]);
    TDTrue( [b3 isEqualToValue:b4]);
    TDTrue(![b3 isEqualToValue:b2]);
}


- (void)testiIsNotEqualToBoolean {
    TDFalse([b1 isNotEqualToValue:b2]);
    TDTrue ([b1 isNotEqualToValue:b3]);
    TDFalse([b2 isNotEqualToValue:b1]);
    TDTrue ([b2 isNotEqualToValue:b3]);
    TDFalse([b3 isNotEqualToValue:b4]);
    TDTrue ([b3 isNotEqualToValue:b2]);
}


- (void)testCompareToBoolean {
    TDTrue ([b1 compareToValue:b2 usingOperator:XPTokenTypeEquals]);
    TDFalse([b1 compareToValue:b2 usingOperator:XPTokenTypeNE]);
    TDFalse([b1 compareToValue:b2 usingOperator:XPTokenTypeLT]);
    TDTrue ([b1 compareToValue:b2 usingOperator:XPTokenTypeLE]);
    TDFalse([b1 compareToValue:b2 usingOperator:XPTokenTypeGT]);
    TDTrue ([b1 compareToValue:b2 usingOperator:XPTokenTypeGE]);

    TDFalse([b1 compareToValue:b3 usingOperator:XPTokenTypeEquals]);
    TDTrue ([b1 compareToValue:b3 usingOperator:XPTokenTypeNE]);
    TDFalse([b1 compareToValue:b3 usingOperator:XPTokenTypeLT]);
    TDFalse([b1 compareToValue:b3 usingOperator:XPTokenTypeLE]);
    TDTrue ([b1 compareToValue:b3 usingOperator:XPTokenTypeGT]);
    TDTrue ([b1 compareToValue:b3 usingOperator:XPTokenTypeGE]);
}


- (void)testIsEqualToString {
    XPValue *s1 = [XPStringValue stringValueWithString:@"0"];
    XPValue *s2 = [XPStringValue stringValueWithString:@""];
    TDTrue ([b1 isEqualToValue:s1]);
    TDFalse([b1 isEqualToValue:s2]);
    TDFalse([b3 isEqualToValue:s1]);
    TDTrue ([b3 isEqualToValue:s2]);
}


- (void)testIsNotEqualToString {
    XPValue *s1 = [XPStringValue stringValueWithString:@"false"];
    XPValue *s2 = [XPStringValue stringValueWithString:@""];
    TDFalse([b1 isNotEqualToValue:s1]);
    TDTrue ([b1 isNotEqualToValue:s2]);
    TDTrue ([b3 isNotEqualToValue:s1]);
    TDFalse([b3 isNotEqualToValue:s2]);
}


- (void)testIsEqualToNumber {
    XPValue *n1 = [XPNumericValue numericValueWithNumber:1];
    XPValue *n2 = [XPNumericValue numericValueWithNumber:0];
    TDTrue ([b1 isEqualToValue:n1]);
    TDFalse([b1 isEqualToValue:n2]);
    TDFalse([b3 isEqualToValue:n1]);
    TDTrue ([b3 isEqualToValue:n2]);
}


- (void)testIsNotEqualToNumber {
    XPValue *n1 = [XPNumericValue numericValueWithNumber:-12];
    XPValue *n2 = [XPNumericValue numericValueWithNumber:NAN];
    TDFalse([b1 isNotEqualToValue:n1]);
    TDTrue ([b1 isNotEqualToValue:n2]);
    TDTrue ([b3 isNotEqualToValue:n1]);
    TDFalse([b3 isNotEqualToValue:n2]);
}


- (void)testEqualsExpr {
    expr = [XPExpression expressionFromString:@"true() != false()" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    expr = [XPExpression expressionFromString:@"false() != true()" inContext:nil error:nil];
    [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    expr = [XPExpression expressionFromString:@"true() = true()" inContext:nil error:nil];
    [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    expr = [XPExpression expressionFromString:@"false() = false()" inContext:nil error:nil];
    [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@end
