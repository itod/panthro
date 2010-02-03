//
//  FNSubstringBeforeTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSubstringBeforeTest.h"

@implementation FNSubstringBeforeTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"substring-before('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-before('1', '2', '3', '4')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-before()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"substring-before('12345', '2')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"1");
    
    expr = [XPExpression expressionFromString:@"substring-before('12345', '6')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"");
    
    expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '/')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"1999");
    
    expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '19')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"");
}


- (void)testNumbers {
    expr = [XPExpression expressionFromString:@"substring-before('12345', 2)" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"1");
}

@end
