//
//  XPStringValueTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPStringValueTest : XCTestCase
@property (nonatomic, retain) XPStringValue *s1;
@property (nonatomic, retain) XPStringValue *s2;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end

@implementation XPStringValueTest

- (void)dealloc {
    self.s1 = nil;
    self.s2 = nil;
    self.expr = nil;
    [super dealloc];
}


- (void)setUp {
    self.s1 = [XPStringValue stringValueWithString:@"foo"];
    self.s2 = [XPStringValue stringValueWithString:@"bar"];
}


- (void)testXPath1Quirks {
    self.expr = [XPExpression expressionFromString:@"'4' = '4'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'4' = '4.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"number('4') = '4.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'4' = number('4.0')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"number('4') = number('4.0')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'4' >= '4.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'4' <= '4.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExpr {
    self.expr = [XPExpression expressionFromString:@"'a' != 'b'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'a' = 'a'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprConcat {
    self.expr = [XPExpression expressionFromString:@"concat('a', 'b') = 'ab'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprSubstringBefore {
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'b') = 'a'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'a') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprSubstringAfter {
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'b') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'a') = 'b'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprLowerCase {
    self.expr = [XPExpression expressionFromString:@"lower-case('') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"lower-case('A') = 'a'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"lower-case('ABc!D') = 'abc!d'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprUpperCase {
    self.expr = [XPExpression expressionFromString:@"upper-case('') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"upper-case('a') = 'A'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"upper-case('abC!d') = 'ABC!D'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprTitleCase {
    self.expr = [XPExpression expressionFromString:@"title-case('') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"title-case('a') = 'A'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"title-case('abC!d') = 'AbC!d'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprCompare {
    self.expr = [XPExpression expressionFromString:@"0 = compare('abc', 'abc')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"compare('abc', 'abc') = 0" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"-1 = compare('abc', 'bc')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"compare('bc', 'abc') = 1" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}


- (void)testEqualsExprNormalizeSpace {
    self.expr = [XPExpression expressionFromString:@"'abc' = normalize-space('abc')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"normalize-space('  abc')" inContext:nil error:nil];
    NSString *str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);

    self.expr = [XPExpression expressionFromString:@"normalize-space('  abc ')" inContext:nil error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);
    
    self.expr = [XPExpression expressionFromString:@"normalize-space('  a   bc ')" inContext:nil error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"a bc", str);
    
}


- (void)testEqualsExprTrimSpace {
    self.expr = [XPExpression expressionFromString:@"'abc' = trim-space('abc')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  abc')" inContext:nil error:nil];
    NSString *str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  abc ')" inContext:nil error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  a   bc ')" inContext:nil error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"a   bc", str);
    
}

@end
