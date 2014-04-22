//
//  FNNotTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNotTest.h"

@implementation FNNotTest

- (void)setUp {

}


- (void)testErrors {
//    self.expr = [XPExpression expressionFromString:@"not(1, 2)" inContext:nil error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
//    
//    self.expr = [XPExpression expressionFromString:@"not()" inContext:nil error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
}


- (void)testBoolean {
    self.expr = [XPExpression expressionFromString:@"not(false())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"not(true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}


- (void)testRelational {
    self.expr = [XPExpression expressionFromString:@"not(1 > 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 < 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}


- (void)testEquality {
    self.expr = [XPExpression expressionFromString:@"not(true() = false())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"not(true() != true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"not(true() = true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not(false() != true())" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not('foo' = 'foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = '1')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = --1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = ---1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    self.expr = [XPExpression expressionFromString:@"not(-1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"not(---1)" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
