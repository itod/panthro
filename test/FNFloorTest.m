//
//  FNFloorTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNFloorTest.h"

@implementation FNFloorTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"floor(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
    
    err = nil;
    expr = [XPExpression expressionFromString:@"floor()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"floor(0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"floor(0.0)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    expr = [XPExpression expressionFromString:@"floor(1.1)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    expr = [XPExpression expressionFromString:@"floor(-1.1)" inContext:nil error:nil];
    res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-2.0, res);
}

@end
