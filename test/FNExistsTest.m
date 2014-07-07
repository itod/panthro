//
//  FNExists.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNExistsTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) BOOL res;
@end

@implementation FNExistsTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"exists()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"exists('1', '2', '3')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"exists('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"exists(('bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);

    self.expr = [XPExpression expressionFromString:@"exists(('foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(-1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(number('asdf'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(number(''))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists('')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists((0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(false())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists((false()))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"exists(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
    
}

@end
