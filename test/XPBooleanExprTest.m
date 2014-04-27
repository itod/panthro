//
//  XPBooleanExprTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPBooleanExprTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end

@implementation XPBooleanExprTest

- (void)dealloc {
    self.expr = nil;
    [super dealloc];
}


- (void)setUp {
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"true() and true()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"true() and false()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"false() and true()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"false() and false()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"true() and true() and false()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"true() and false() and true()" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}

@end
