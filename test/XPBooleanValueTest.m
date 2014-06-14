//
//  XPBooleanValueTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPBooleanValueTest : XCTestCase
@property (nonatomic, retain) XPBooleanValue *b1;
@property (nonatomic, retain) XPBooleanValue *b2;
@property (nonatomic, retain) XPBooleanValue *b3;
@property (nonatomic, retain) XPBooleanValue *b4;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end

@implementation XPBooleanValueTest

- (void)dealloc {
    self.b1 = nil;
    self.b2 = nil;
    self.b3 = nil;
    self.b4 = nil;
    self.expr = nil;
    [super dealloc];
}


- (void)setUp {
    self.b1 = [XPBooleanValue booleanValueWithBoolean:YES];
    self.b2 = [XPBooleanValue booleanValueWithBoolean:YES];
    self.b3 = [XPBooleanValue booleanValueWithBoolean:NO];
    self.b4 = [XPBooleanValue booleanValueWithBoolean:NO];
}


- (void)testAsString {
    TDEqualObjects([_b1 asString], @"true");
    TDEqualObjects([_b3 asString], @"false");
}


- (void)testAsNumber {
    TDEquals([_b1 asNumber], 1.0);
    TDEquals([_b3 asNumber], 0.0);
}


- (void)testIsEqualToBoolean {
    TDTrue( [_b1 isEqualToValue:_b2]);
    TDTrue(![_b1 isEqualToValue:_b3]);
    TDTrue( [_b2 isEqualToValue:_b1]);
    TDTrue(![_b2 isEqualToValue:_b3]);
    TDTrue( [_b3 isEqualToValue:_b4]);
    TDTrue(![_b3 isEqualToValue:_b2]);
}


- (void)testiIsNotEqualToBoolean {
    TDFalse([_b1 isNotEqualToValue:_b2]);
    TDTrue ([_b1 isNotEqualToValue:_b3]);
    TDFalse([_b2 isNotEqualToValue:_b1]);
    TDTrue ([_b2 isNotEqualToValue:_b3]);
    TDFalse([_b3 isNotEqualToValue:_b4]);
    TDTrue ([_b3 isNotEqualToValue:_b2]);
}


- (void)testCompareToBoolean {
    TDTrue ([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_EQUALS]);
    TDFalse([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_NOT_EQUAL]);
    TDFalse([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_LT_SYM]);
    TDTrue ([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_LE_SYM]);
    TDFalse([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_GT_SYM]);
    TDTrue ([_b1 compareToValue:_b2 usingOperator:XPEG_TOKEN_KIND_GE_SYM]);

    TDFalse([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_EQUALS]);
    TDTrue ([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_NOT_EQUAL]);
    TDFalse([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_LT_SYM]);
    TDFalse([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_LE_SYM]);
    TDTrue ([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_GT_SYM]);
    TDTrue ([_b1 compareToValue:_b3 usingOperator:XPEG_TOKEN_KIND_GE_SYM]);
}


- (void)testIsEqualToString {
    XPValue *s1 = [XPStringValue stringValueWithString:@"0"];
    XPValue *s2 = [XPStringValue stringValueWithString:@""];
    TDTrue ([_b1 isEqualToValue:s1]);
    TDFalse([_b1 isEqualToValue:s2]);
    TDFalse([_b3 isEqualToValue:s1]);
    TDTrue ([_b3 isEqualToValue:s2]);
}


- (void)testIsNotEqualToString {
    XPValue *s1 = [XPStringValue stringValueWithString:@"false"];
    XPValue *s2 = [XPStringValue stringValueWithString:@""];
    TDFalse([_b1 isNotEqualToValue:s1]);
    TDTrue ([_b1 isNotEqualToValue:s2]);
    TDTrue ([_b3 isNotEqualToValue:s1]);
    TDFalse([_b3 isNotEqualToValue:s2]);
}


- (void)testIsEqualToNumber {
    XPValue *n1 = [XPNumericValue numericValueWithNumber:1];
    XPValue *n2 = [XPNumericValue numericValueWithNumber:0];
    TDTrue ([_b1 isEqualToValue:n1]);
    TDFalse([_b1 isEqualToValue:n2]);
    TDFalse([_b3 isEqualToValue:n1]);
    TDTrue ([_b3 isEqualToValue:n2]);
}


- (void)testIsNotEqualToNumber {
    XPValue *n1 = [XPNumericValue numericValueWithNumber:-12];
    XPValue *n2 = [XPNumericValue numericValueWithNumber:NAN];
    TDFalse([_b1 isNotEqualToValue:n1]);
    TDTrue ([_b1 isNotEqualToValue:n2]);
    TDTrue ([_b3 isNotEqualToValue:n1]);
    TDFalse([_b3 isNotEqualToValue:n2]);
}


- (void)testEqualsExpr {
    self.expr = [XPExpression expressionFromString:@"true() != false()" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"false() != true()" inContext:[XPStandaloneContext standaloneContext] error:nil];
    [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"true() = true()" inContext:[XPStandaloneContext standaloneContext] error:nil];
    [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"false() = false()" inContext:[XPStandaloneContext standaloneContext] error:nil];
    [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
