//
//  XPRangeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPArithmeticExpression.h"
#import "XPRelationalExpression.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "XPBooleanValue.h"

@interface XPRangeTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@end

@implementation XPRangeTest

- (void)setUp {
    [super setUp];
    
}


- (void)tearDown {
    self.expr = nil;
    [super tearDown];
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"1" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(0, _expr.range.location);
    TDEquals(1, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"12345" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(0, _expr.range.location);
    TDEquals(5, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"-1" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(0, _expr.range.location);
    TDEquals(2, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"-12345" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(0, _expr.range.location);
    TDEquals(6, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"0.0" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(0, _expr.range.location);
    TDEquals(3, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@" 0.0" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEquals(1, _expr.range.location);
    TDEquals(3, _expr.range.length);
}


- (void)testArithmeticExprs {
    self.expr = [XPExpression expressionFromString:@"1 + 1" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEqualObjects([_expr class], [XPArithmeticExpression class]);
    TDEquals(0, _expr.range.location);
    TDEquals(5, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"1 + 1" inContext:[XPStandaloneContext standaloneContext] simplify:YES error:nil];
    TDEqualObjects([_expr class], [XPNumericValue class]);
    TDEquals(0, _expr.range.location);
    TDEquals(5, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"1 = 1" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEqualObjects([_expr class], [XPRelationalExpression class]);
    TDEquals(0, _expr.range.location);
    TDEquals(5, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"1 = 1" inContext:[XPStandaloneContext standaloneContext] simplify:YES error:nil];
    TDEqualObjects([_expr class], [XPBooleanValue class]);
    TDEquals(0, _expr.range.location);
    TDEquals(5, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"1 != 1" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEqualObjects([_expr class], [XPRelationalExpression class]);
    TDEquals(0, _expr.range.location);
    TDEquals(6, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"1 != 1" inContext:[XPStandaloneContext standaloneContext] simplify:YES error:nil];
    TDEqualObjects([_expr class], [XPBooleanValue class]);
    TDEquals(0, _expr.range.location);
    TDEquals(6, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"2 >= 3" inContext:[XPStandaloneContext standaloneContext] simplify:NO error:nil];
    TDEqualObjects([_expr class], [XPRelationalExpression class]);
    TDEquals(0, _expr.range.location);
    TDEquals(6, _expr.range.length);
    
    self.expr = [XPExpression expressionFromString:@"2 >= 3" inContext:[XPStandaloneContext standaloneContext] simplify:YES error:nil];
    TDEqualObjects([_expr class], [XPBooleanValue class]);
    TDEquals(0, _expr.range.location);
    TDEquals(6, _expr.range.length);
    
}

@end
