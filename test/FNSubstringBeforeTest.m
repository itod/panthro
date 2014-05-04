//
//  FNSubstringBeforeTest.m
//  XPath
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
    TDNil(err);
    
    [XPExpression expressionFromString:@"substring-before('1', '2', '3', '4')" inContext:nil error:&err];
    TDNil(err);
    
    [XPExpression expressionFromString:@"substring-before()" inContext:nil error:&err];
    TDNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', '2')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', '6')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '/')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1999");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '19')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', 2)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1");
}

@end
