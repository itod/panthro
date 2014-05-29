//
//  FNFloorTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNFloorTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) double res;
@end

@implementation FNFloorTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"floor(1, 2)" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    err = nil;
    self.expr = [XPExpression expressionFromString:@"floor()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"floor(0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"floor(0.0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"floor(1.1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"floor(-1.1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-2.0, _res);
}

@end
