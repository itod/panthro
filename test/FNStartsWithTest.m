//
//  FNStartsWithTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStartsWithTest.h"

@implementation FNStartsWithTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"starts-with('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"starts-with()" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"starts-with('1', '2', '3')" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"starts-with('foo', 'bar')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"starts-with('foo', 'foobar')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
    
    self.expr = [XPExpression expressionFromString:@"starts-with('foobar', 'foo')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
