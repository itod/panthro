//
//  FNConcatTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNConcatTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) NSString *res;
@end

@implementation FNConcatTest

- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"concat('foo')" inContext:nil error:&err];
    TDNil(err);
    
    [XPExpression expressionFromString:@"concat()" inContext:nil error:&err];
    TDNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"concat('foo', 'bar')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foobar");
}


- (void)testEqualsExprConcat {
    self.expr = [XPExpression expressionFromString:@"concat('a', 'b') = 'ab'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
