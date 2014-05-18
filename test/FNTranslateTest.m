//
//  FNTranslateTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNTranslateTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) BOOL res;
@end

@implementation FNTranslateTest

- (void)setUp {
    
}


- (void)testEqualsExprTranslate {
    self.expr = [XPExpression expressionFromString:@"translate('bar', 'abc', 'ABC') = 'BAr'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'AAA' = translate('--aaa--','abc-','ABC')" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
