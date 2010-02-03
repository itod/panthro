//
//  FNBooleanTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNBooleanTest.h"

@implementation FNBooleanTest

- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"boolean(1, 2)" inContext:nil error:&err];
    TDNotNil(err);

    err = nil;
    [XPExpression expressionFromString:@"boolean()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testBoolean {
    expr = [XPExpression expressionFromString:@"boolean(false())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testRelational {
    expr = [XPExpression expressionFromString:@"boolean(1 > 2)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(1 < 2)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"boolean('')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean('foo')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean('false')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"boolean(0)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(0.0)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean(0.001)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean(1 - 2)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    expr = [XPExpression expressionFromString:@"boolean(1 - 1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);

    expr = [XPExpression expressionFromString:@"boolean(1 = --1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean(1 = ---1)" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);    
}


- (void)testEquality {
    expr = [XPExpression expressionFromString:@"boolean(true() = false())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(true() != true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"boolean(true() = true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean(false() != true())" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean('foo' = 'foo')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"boolean(1 = '1')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@end
