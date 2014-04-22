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
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"string()" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDNil(res);
    
    self.expr = [XPExpression expressionFromString:@"string(1)" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"1");
    
    self.expr = [XPExpression expressionFromString:@"string(-1.0)" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"-1");
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"string(true())" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"true");
    
    self.expr = [XPExpression expressionFromString:@"string(false())" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"false");
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"string('foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"foo");
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
