//
//  FNNumberTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNumberTest.h"

@implementation FNNumberTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"number(1, 2)" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"number(1)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    self.expr = [XPExpression expressionFromString:@"number()" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(res));
    
    self.expr = [XPExpression expressionFromString:@"number(0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"number(-0)" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-0.0, res);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"number('0')" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
    
    self.expr = [XPExpression expressionFromString:@"ceiling('2.0')" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(2.0, res);
    
    self.expr = [XPExpression expressionFromString:@"ceiling('-1.1')" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, res);
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"number(true())" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, res);
    
    self.expr = [XPExpression expressionFromString:@"number(false())" inContext:nil error:nil];
    self.res = [expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
