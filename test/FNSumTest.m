//
//  FNSumTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNSumTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) double res;
@end

@implementation FNSumTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"sum()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"sum('1', '2')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"sum((0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((-1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1, 2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((0, 1, 2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1, 2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1, -2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1, -2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((-1, -2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((-1, -2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"sum((1.1, -2, 0.0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEqualsWithAccuracy(-0.9, _res, 0.01);
    
    self.expr = [XPExpression expressionFromString:@"sum((1.1, -2.0, 0.0), -1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEqualsWithAccuracy(-0.9, _res, 0.01);
    
    self.expr = [XPExpression expressionFromString:@"sum((1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"sum((0, 1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"sum((-5, 0, 1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
}


- (void)testEmpty {
    self.expr = [XPExpression expressionFromString:@"sum(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);

    self.expr = [XPExpression expressionFromString:@"sum((), -1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"sum(('foo'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"sum(('foo', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
}

@end
