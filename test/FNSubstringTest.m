//
//  FNSubstringTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNSubstringTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) NSString *res;
@end

@implementation FNSubstringTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"substring('foo')" inContext:nil error:&err];
    TDNil(err);
    
    [XPExpression expressionFromString:@"substring('1', '2', '3', '4')" inContext:nil error:&err];
    TDNil(err);
    
    [XPExpression expressionFromString:@"substring()" inContext:nil error:&err];
    TDNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"substring('12345', 2, 3)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"234");
    
    self.expr = [XPExpression expressionFromString:@"substring('foo', 1)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");

    self.expr = [XPExpression expressionFromString:@"substring('12345', 2)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"2345");
}

@end
