//
//  FNDistinctValuesTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"
#import "XPEmptySequence.h"

@interface FNDistinctValuesTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) id res;
@end

@implementation FNDistinctValuesTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"distinct-values()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"distinct-values('1', '2', '3')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testDistinct {
    self.expr = [XPExpression expressionFromString:@"distinct-values((1, 'foobar', 'bar', 1, 1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEqualObjects(@"bar", [[_res itemAt:1] asString]);
    TDEqualObjects(@"foobar", [[_res itemAt:2] asString]);
    TDEquals(3, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(('foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEqualObjects(@"bar", [[_res itemAt:0] asString]);
    TDEqualObjects(@"foobar", [[_res itemAt:1] asString]);
    TDEquals(2, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(('foobar', 'foobar', 'bar', 'foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEqualObjects(@"bar", [[_res itemAt:0] asString]);
    TDEqualObjects(@"foobar", [[_res itemAt:1] asString]);
    TDEquals(2, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values((2,4,3,1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(2.0, [[_res itemAt:1] asNumber]);
    TDEquals(3.0, [[_res itemAt:2] asNumber]);
    TDEquals(4.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values((2,4,3,4,4,2,1))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(2.0, [[_res itemAt:1] asNumber]);
    TDEquals(3.0, [[_res itemAt:2] asNumber]);
    TDEquals(4.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"distinct-values('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"foo", _res);

    self.expr = [XPExpression expressionFromString:@"distinct-values(('bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"bar", _res);

    self.expr = [XPExpression expressionFromString:@"distinct-values(0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(0.0, [_expr evaluateAsNumberInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(-1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(-1, [_res asNumber]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(number('asdf'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDTrue(isnan([_expr evaluateAsNumberInContext:nil]));
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(number(''))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDTrue(isnan([_expr evaluateAsNumberInContext:nil]));
    
    self.expr = [XPExpression expressionFromString:@"distinct-values('')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"", _res);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values((0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(0.0, [_expr evaluateAsNumberInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(false())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1, [_res count]);
    TDEquals(NO, [_res asBoolean]);
    
    self.expr = [XPExpression expressionFromString:@"boolean(distinct-values(false()))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(NO, [_expr evaluateAsBooleanInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"boolean(distinct-values((false())))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(NO, [_expr evaluateAsBooleanInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"boolean(distinct-values((0.0)))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(NO, [_expr evaluateAsBooleanInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"boolean(distinct-values(true()))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(YES, [_expr evaluateAsBooleanInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"boolean(distinct-values((true())))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDEquals(YES, [_expr evaluateAsBooleanInContext:nil]);
    
    self.expr = [XPExpression expressionFromString:@"distinct-values(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    TDTrue([XPEmptySequence instance] == [_expr evaluateAsNodeSetInContext:nil]);
    TDTrue([XPEmptySequence instance] == [_expr evaluateInContext:nil]);
}

@end
