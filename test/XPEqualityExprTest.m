//
//  XPEqualityExprTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPEqualityExprTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end

@implementation XPEqualityExprTest

- (void)dealloc {
    self.expr = nil;
    [super dealloc];
}


- (void)setUp {
}


- (void)testTransitivity {
    self.expr = [XPExpression expressionFromString:@"1=true()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"true()='true'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"1='true'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testNums {
    self.expr = [XPExpression expressionFromString:@"'2'='2.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"'2'<='2.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"'2'>='2.0'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
