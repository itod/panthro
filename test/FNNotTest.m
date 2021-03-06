//
//  FNNotTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNNotTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) BOOL res;
@end

@implementation FNNotTest

- (void)setUp {

}


- (void)testErrors {
//    self.expr = [XPExpression expressionFromString:@"not(1, 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
//    
//    self.expr = [XPExpression expressionFromString:@"not()" inContext:[XPStandaloneContext standaloneContext] error:nil];
//    STAssertThrowsSpecificNamed([expr simplify], NSException, @"XPathException", @"");
}


- (void)testBoolean {
    self.expr = [XPExpression expressionFromString:@"not(false())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(true())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testRelational {
    self.expr = [XPExpression expressionFromString:@"not(1 > 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 < 2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testEquality {
    self.expr = [XPExpression expressionFromString:@"not(true() = false())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(true() != true())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(true() = true())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(false() != true())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not('foo' = 'foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = '1')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = --1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(1 = ---1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(-1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
    self.expr = [XPExpression expressionFromString:@"not(---1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}

@end
