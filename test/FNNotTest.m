//
//  FNNotTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNotTest.h"

@implementation FNNotTest

- (void)setUp {
    p = [[[XPParser alloc] init] autorelease];
}


- (void)testErrors {
//    expr = [XPExpression expressionFromString:@"not(1, 2)" inContext:nil error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
//    
//    expr = [XPExpression expressionFromString:@"not()" inContext:nil error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
}


- (void)testBoolean {
    expr = [XPExpression expressionFromString:@"not(false())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"not(true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}


- (void)testRelational {
    expr = [XPExpression expressionFromString:@"not(1 > 2)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"not(1 < 2)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}


- (void)testEquality {
    expr = [XPExpression expressionFromString:@"not(true() = false())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"not(true() != true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"not(true() = true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not(false() != true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not('foo' = 'foo')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not(1 = '1')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not(1 = --1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not(1 = ---1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"not(-1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"not(---1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}

@end
