//
//  FNCountTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNCountTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) double res;
@end

@implementation FNCountTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"count()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);

    [XPExpression expressionFromString:@"count('1', '2', '3')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"count(('foo', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(2.0, _res);
}

@end
