//
//  XPBooleanExprTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanExprTest.h"

@implementation XPBooleanExprTest

- (void)setUp {
}


- (void)testBooleans {
    expr = [XPExpression expressionFromString:@"true() and true()" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"true() and false()" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    expr = [XPExpression expressionFromString:@"false() and true()" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
}

@end
