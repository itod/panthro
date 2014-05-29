//
//  FNTrimSpaceTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNTrimSpaceTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) BOOL res;
@end

@implementation FNTrimSpaceTest

- (void)setUp {
    
}


- (void)testEqualsExprTrimSpace {
    self.expr = [XPExpression expressionFromString:@"'abc' = trim-space('abc')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  abc')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    NSString *str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  abc ')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"abc", str);
    
    self.expr = [XPExpression expressionFromString:@"trim-space('  a   bc ')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    str = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"a   bc", str);
}

@end
