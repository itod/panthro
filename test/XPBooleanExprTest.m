//
//  XPBooleanExprTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanExprTest.h"

@implementation XPBooleanExprTest

- (void)dealloc {
    self.self.expr = nil;
    [super dealloc];
}


- (void)setUp {
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"true() and true()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"true() and false()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"false() and true()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"false() and false()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"true() and true() and false()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"true() and false() and true()" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}

@synthesize expr;
@synthesize res;
@end
