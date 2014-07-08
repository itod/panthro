//
//  FNExists.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"
#import "XPEmptySequence.h"

@interface FNDataTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) id res;
@end

@implementation FNDataTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"data()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"data('1', '2', '3')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"data('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"foo", _res);

    self.expr = [XPExpression expressionFromString:@"data(('bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"bar", _res);

    self.expr = [XPExpression expressionFromString:@"data(('foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNodeSetInContext:nil];
    TDEqualObjects(@"foobar", [[_res itemAt:0] asString]);
    TDEqualObjects(@"bar", [[_res itemAt:1] asString]);
    
    self.expr = [XPExpression expressionFromString:@"data(0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res asNumber]);
    
    self.expr = [XPExpression expressionFromString:@"data(-1)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(-1, [_res asNumber]);
    
//    self.expr = [XPExpression expressionFromString:@"data(number('asdf'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
//    self.res = [_expr evaluateInContext:nil];
//    TDTrue(isnan([_res asNumber]));
    
    self.expr = [XPExpression expressionFromString:@"data(number(''))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDTrue(isnan([_res asNumber]));
    
    self.expr = [XPExpression expressionFromString:@"data('')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(@"", _res);
    
    self.expr = [XPExpression expressionFromString:@"data((0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(0, [_res asNumber]);
    
    self.expr = [XPExpression expressionFromString:@"data(false())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(NO, [_res asBoolean]);
    
    self.expr = [XPExpression expressionFromString:@"data((false()))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDEquals(NO, [_res asBoolean]);
    
    self.expr = [XPExpression expressionFromString:@"data(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateInContext:nil];
    TDTrue([XPEmptySequence instance] == _res);
}

@end
