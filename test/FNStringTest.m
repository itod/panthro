//
//  FNStringTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStringTest.h"

@implementation FNStringTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"string(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"string()" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDNil(res);
    
    expr = [XPExpression expressionFromString:@"string(1)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"1");
    
    expr = [XPExpression expressionFromString:@"string(-1.0)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"-1");
}


- (void)testBooleans {
    expr = [XPExpression expressionFromString:@"string(true())" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"true");
    
    expr = [XPExpression expressionFromString:@"string(false())" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"false");
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"string('foo')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"foo");
}

@end
