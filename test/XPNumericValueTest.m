//
//  XPNumericValueTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPNumericValueTest : XCTestCase
@property (nonatomic, retain) XPNumericValue *n1;
@property (nonatomic, retain) XPNumericValue *n2;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) double res;
@end

@implementation XPNumericValueTest

- (void)dealloc {
    self.n1 = nil;
    self.n2 = nil;
    self.expr =nil;
    [super dealloc];
}


- (void)setUp {
    self.n1 = [XPNumericValue numericValueWithNumber:1];
    self.n2 = [XPNumericValue numericValueWithNumber:2];
}


- (void)testRelationalExpr {    
    self.expr =[XPExpression expressionFromString:@"1 != 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 = 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"42.0 = 42" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"3.140 = 3.14" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 < 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 <= 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 > 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 >= 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = '1'" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr =[XPExpression expressionFromString:@"'1' = 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = --1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = ---1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);    
}


- (void)testArithmeticExpr {
    self.expr =[XPExpression expressionFromString:@"1 + 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"1 - 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"3 * 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(6.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"9 div 3" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"10 mod 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
}

@end
