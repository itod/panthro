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
@end

@implementation FNConcatTest

- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"concat('foo')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"concat()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"concat('foo', 'bar')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    NSString *res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"foobar");
}


- (void)testEqualsExprConcat {
    self.expr = [XPExpression expressionFromString:@"concat('a', 'b') = 'ab'" inContext:[XPStandaloneContext standaloneContext] error:nil];
    BOOL res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@end
