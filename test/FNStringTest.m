//
//  FNStringTest.m
//  XPath
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
    TDNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"string()" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDNil(_res);
    
    self.expr = [XPExpression expressionFromString:@"string(1)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1");
    
    self.expr = [XPExpression expressionFromString:@"string(-1.0)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"-1");
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"string(true())" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"true");
    
    self.expr = [XPExpression expressionFromString:@"string(false())" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"false");
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"string('foo')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");
}

@end
