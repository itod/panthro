//
//  FNNumberTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNumberTest.h"

@implementation FNNumberTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"number(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"number()" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals((double)NAN, res);
    
    expr = [XPExpression expressionFromString:@"number(0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"number(-0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-0.0, res);
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"number('0')" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"ceiling('2.0')" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(2.0, res);
    
    expr = [XPExpression expressionFromString:@"ceiling('-1.1')" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, res);
}


- (void)testBooleans {
    expr = [XPExpression expressionFromString:@"number(true())" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    expr = [XPExpression expressionFromString:@"number(false())" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
}

@end
