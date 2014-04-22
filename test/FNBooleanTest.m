//
//  FNBooleanTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNBooleanTest.h"

@implementation FNBooleanTest

- (void)dealloc {
    self.expr = nil;
    self.fn = nil;
    [super dealloc];
}


- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"boolean(1, 2)" inContext:nil error:&err];
    TDNotNil(err);

    err = nil;
    [XPExpression expressionFromString:@"boolean()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testBoolean {
    self.expr = [XPExpression expressionFromString:@"boolean(false())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testRelational {
    self.expr = [XPExpression expressionFromString:@"boolean(1 > 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(1 < 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"boolean('')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean('foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean('false')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"boolean(0)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(0.0)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(0.001)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(1 - 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);

    self.expr = [XPExpression expressionFromString:@"boolean(1 - 1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);

    self.expr = [XPExpression expressionFromString:@"boolean(1 = --1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(1 = ---1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);    
}


- (void)testEquality {
    self.expr = [XPExpression expressionFromString:@"boolean(true() = false())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(true() != true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(true() = true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(false() != true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean('foo' = 'foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"boolean(1 = '1')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
