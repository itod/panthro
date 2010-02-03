//
//  FNConcatTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNConcatTest.h"

@implementation FNConcatTest

- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"concat('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"concat()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    expr = [XPExpression expressionFromString:@"concat('foo', 'bar')" inContext:nil error:nil];
    res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"foobar");
}

@end
