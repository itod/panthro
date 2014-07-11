//
//  FNInsertBeforeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"

@interface FNInsertBeforeTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) id res;
@end

@implementation FNInsertBeforeTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"insert-before()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"insert-before('foo')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"insert-before('foo', 'bar')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"insert-before('1', '2', '3', '4')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testSingle {
    self.expr = [XPExpression expressionFromString:@"insert-before('2', 1, '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(2.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);
}


- (void)testSingleEmpty {
    self.expr = [XPExpression expressionFromString:@"insert-before((), 1, '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)testInsertEmptySequence {
    self.expr = [XPExpression expressionFromString:@"insert-before('1', 1, ())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)test4At1 {
    self.expr = [XPExpression expressionFromString:@"insert-before((2, 3, 4), 1, 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(2.0, [[_res itemAt:1] asNumber]);
    TDEquals(3.0, [[_res itemAt:2] asNumber]);
    TDEquals(4.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
}


- (void)test4At2 {
    self.expr = [XPExpression expressionFromString:@"insert-before(('2', '3', '4'), 2, '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(2.0, [[_res itemAt:0] asNumber]);
    TDEquals(1.0, [[_res itemAt:1] asNumber]);
    TDEquals(3.0, [[_res itemAt:2] asNumber]);
    TDEquals(4.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
}


- (void)test4At3 {
    self.expr = [XPExpression expressionFromString:@"insert-before((2, 3, 4), 3, 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(2.0, [[_res itemAt:0] asNumber]);
    TDEquals(3.0, [[_res itemAt:1] asNumber]);
    TDEquals(1.0, [[_res itemAt:2] asNumber]);
    TDEquals(4.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
}


- (void)test4At4 {
    self.expr = [XPExpression expressionFromString:@"insert-before((2, 3, 4), 4, 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(2.0, [[_res itemAt:0] asNumber]);
    TDEquals(3.0, [[_res itemAt:1] asNumber]);
    TDEquals(4.0, [[_res itemAt:2] asNumber]);
    TDEquals(1.0, [[_res itemAt:3] asNumber]);
    TDEquals(4, [_res count]);
}

@end
