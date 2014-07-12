//
//  FNRemoveTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"

@interface FNRemoveTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) id res;
@end

@implementation FNRemoveTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"remove('foo')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"remove()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"remove('1', '2', '3')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testSingle {
    self.expr = [XPExpression expressionFromString:@"remove('1', 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"remove(('1'), 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res count]);
}


- (void)testOutOfBounds {
    self.expr = [XPExpression expressionFromString:@"remove('1', -1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"remove(('1'), 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)testEmptySequence {
    self.expr = [XPExpression expressionFromString:@"remove((), '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res count]);

    self.expr = [XPExpression expressionFromString:@"remove('1', ())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)testEmptySequence1 {
    self.expr = [XPExpression expressionFromString:@"remove(('2', '3', '4'), '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(3.0, [[_res itemAt:0] asNumber]);
    TDEquals(4.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);

    self.expr = [XPExpression expressionFromString:@"remove(('2', '3', '4'), 1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(3.0, [[_res itemAt:0] asNumber]);
    TDEquals(4.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);
}


- (void)testStringTwice {
    self.expr = [XPExpression expressionFromString:@"remove(('4', '3', '2', '1'), '2')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(4.0, [[_res itemAt:0] asNumber]);
    TDEquals(2.0, [[_res itemAt:1] asNumber]);
    TDEquals(1.0, [[_res itemAt:2] asNumber]);
    TDEquals(3, [_res count]);

    self.expr = [XPExpression expressionFromString:@"remove((2, 3, 4, 2), 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(2.0, [[_res itemAt:0] asNumber]);
    TDEquals(4.0, [[_res itemAt:1] asNumber]);
    TDEquals(2.0, [[_res itemAt:2] asNumber]);
    TDEquals(3, [_res count]);
}

@end
