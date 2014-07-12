//
//  FNIndexOfTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"

@interface FNIndexOfTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) id res;
@end

@implementation FNIndexOfTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"index-of('foo')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"index-of()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"index-of('1', '2', '3', '4')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testSingle {
    self.expr = [XPExpression expressionFromString:@"index-of('1', '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)testEmptySequence {
    self.expr = [XPExpression expressionFromString:@"index-of((), '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res count]);
}


- (void)testEmptySequence1 {
    self.expr = [XPExpression expressionFromString:@"index-of(('2', '3', '4'), '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res count]);
}


- (void)testStringTwice {
    self.expr = [XPExpression expressionFromString:@"index-of(('2', '3', '4', '2'), '2')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(4.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);
}


- (void)testNumberTwice {
    self.expr = [XPExpression expressionFromString:@"index-of((2, 3, 4, 2), 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(4.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);
}

@end
