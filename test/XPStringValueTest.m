//
//  XPStringValueTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPStringValueTest.h"

@implementation XPStringValueTest

- (void)setUp {
    s1 = [XPStringValue stringValueWithString:@"foo"];
    s2 = [XPStringValue stringValueWithString:@"bar"];
}


- (void)testEqualsExpr {
    expr = [XPExpression expressionFromString:@"'a' != 'b'" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
    
    expr = [XPExpression expressionFromString:@"'a' = 'a'" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@end
