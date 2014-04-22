//
//  XPStringValueTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPStringValueTest.h"

@implementation XPStringValueTest

- (void)dealloc {
    self.s1 = nil;
    self.s2 = nil;
    self.self.expr = nil;
    [super dealloc];
}


- (void)setUp {
    self.s1 = [XPStringValue stringValueWithString:@"foo"];
    self.s2 = [XPStringValue stringValueWithString:@"bar"];
}


- (void)testEqualsExpr {
    self.expr = [XPExpression expressionFromString:@"'a' != 'b'" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"'a' = 'a'" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testEqualsExprConcat {
    self.expr = [XPExpression expressionFromString:@"concat('a', 'b') = 'ab'" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testEqualsExprSubstringBefore {
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'b') = 'a'" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'a') = ''" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testEqualsExprSubstringAfter {
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'b') = ''" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'a') = 'b'" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@synthesize s1;
@synthesize s2;
@synthesize expr;
@synthesize res;
@end
