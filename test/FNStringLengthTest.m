//
//  FNStringLengthTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStringLengthTest.h"

@implementation FNStringLengthTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"string-length(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"string-length()" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(-0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(2.0, res);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"string-length()" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"string-length('foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, res);
    
    self.expr = [XPExpression expressionFromString:@"string-length('')" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"string-length(true())" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(4.0, res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(false())" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(5.0, res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
