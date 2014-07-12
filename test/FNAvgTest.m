//
//  FNAvgTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNAvgTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) double res;
@end

@implementation FNAvgTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"avg()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"avg('1', '2')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"avg((0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((-1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1, 2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.5, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((0, 1, 2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1, 2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1, -2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-0.5, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1, -2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-(1.0/3.0), _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((-1, -2, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((-1, -2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.5, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1.1, -2, 0.0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-0.3, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1.1, -2.0, 0.0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-0.3, _res);
    
    self.expr = [XPExpression expressionFromString:@"avg((1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"avg((0, 1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"avg((-5, 0, 1, 2, number('')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
}


- (void)testEmpty {
    self.expr = [XPExpression expressionFromString:@"avg(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    id res = [_expr evaluateAsSequenceInContext:nil];
    TDEquals(0.0, [res count]);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"avg(('foo'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
    
    self.expr = [XPExpression expressionFromString:@"avg(('foo', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDTrue(isnan(_res));
}

@end
