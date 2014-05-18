//
//  FNAbsTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNAbsTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) double res;
@end

@implementation FNAbsTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"abs(1, 2)" inContext:nil error:&err];
    TDNil(err);
    
    err = nil;
    self.expr = [XPExpression expressionFromString:@"abs()" inContext:nil error:&err];
    TDNil(err);
}


- (void)testNumericFunctions {
    self.expr =[XPExpression expressionFromString:@"abs(2.5)" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(2.5, _res);
    
    self.expr =[XPExpression expressionFromString:@"abs(-5.0)" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(5.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"abs(-5.1)" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(5.1, _res);
}

@end
