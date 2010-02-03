//
//  XPNumericValueTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNumericValueTest.h"

@implementation XPNumericValueTest

- (void)setUp {
    n1 = [XPNumericValue numericValueWithNumber:1];
    n2 = [XPNumericValue numericValueWithNumber:2];
}


- (void)testRelationalExpr {    
    expr = [XPExpression expressionFromString:@"1 != 2" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"2 = 2" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"42.0 = 42" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"3.140 = 3.14" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"1 < 2" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"1 <= 2" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"2 > 1" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"2 >= 1" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"1 = '1'" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    expr = [XPExpression expressionFromString:@"'1' = 1" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"1 = --1" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"1 = ---1" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);    
}


- (void)testArithmeticExpr {
    expr = [XPExpression expressionFromString:@"1 + 2" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, res);
    
    expr = [XPExpression expressionFromString:@"1 - 2" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, res);
    
    expr = [XPExpression expressionFromString:@"3 * 2" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(6.0, res);
    
    expr = [XPExpression expressionFromString:@"9 div 3" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, res);
    
    expr = [XPExpression expressionFromString:@"10 mod 2" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
}

@end
