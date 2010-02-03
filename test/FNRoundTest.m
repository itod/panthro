//
//  FNRoundTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNRoundTest.h"

@implementation FNRoundTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"round(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
    
    err = nil;
    expr = [XPExpression expressionFromString:@"round()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"round(0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"round(0.0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"round(1.1)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    expr = [XPExpression expressionFromString:@"round(-1.1)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, res);
}

@end
