//
//  FNSubstringTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSubstringTest.h"

@implementation FNSubstringTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"substring('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring('1', '2', '3', '4')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"substring('12345', 2, 3)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"234");
    
    expr = [XPExpression expressionFromString:@"substring('foo', 1)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"foo");

    expr = [XPExpression expressionFromString:@"substring('12345', 2)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"2345");
}

@end
