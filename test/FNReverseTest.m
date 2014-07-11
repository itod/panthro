//
//  FNReverseTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"

@interface FNReverseTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) id res;
@end

@implementation FNReverseTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"reverse()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"reverse('1', '2')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testSingle {
    self.expr = [XPExpression expressionFromString:@"reverse('1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [[_res itemAt:0] asNumber]);
    TDEquals(1, [_res count]);
}


- (void)testEmptySequence {
    self.expr = [XPExpression expressionFromString:@"reverse(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEqualObjects([XPEmptySequence instance], _res);
    TDEquals(0, [_res count]);
}


- (void)testRev3 {
    self.expr = [XPExpression expressionFromString:@"reverse(('2', '3', '4'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(4.0, [[_res itemAt:0] asNumber]);
    TDEquals(3.0, [[_res itemAt:1] asNumber]);
    TDEquals(2.0, [[_res itemAt:2] asNumber]);
    TDEquals(3, [_res count]);
}


- (void)testRev2 {
    self.expr = [XPExpression expressionFromString:@"reverse((1, 2))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(2.0, [[_res itemAt:0] asNumber]);
    TDEquals(1.0, [[_res itemAt:1] asNumber]);
    TDEquals(2, [_res count]);
}

@end
