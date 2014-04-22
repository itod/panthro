//
//  FNContainsTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNContainsTest.h"

@implementation FNContainsTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"contains('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"contains()" inContext:nil error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"contains('1', '2', '3')" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"contains('foo', 'bar')" inContext:nil error:nil];
    self.res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
