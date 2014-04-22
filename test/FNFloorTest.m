//
//  FNFloorTest.m
//  XPath
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
    self.expr = [XPExpression expressionFromString:@"floor()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"floor(0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"floor(0.0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"floor(1.1)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    self.expr = [XPExpression expressionFromString:@"floor(-1.1)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-2.0, res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
