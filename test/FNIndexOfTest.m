//
//  FNIndexOfTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNIndexOfTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) XPValue *res;
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


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"index-of('1', '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(1.0, [(id)[_res head] asNumber]);
}

@end
