//
//  FNTailTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"
#import "XPEmptySequence.h"

@interface FNTailTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) id res;
@end

@implementation FNTailTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"tail()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"tail('1', '2')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"tail(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"", [_res stringValue]);
    TDEquals(0, [_res count]);

    self.expr = [XPExpression expressionFromString:@"tail('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"", [_res stringValue]);
    TDEquals(0, [_res count]);

    self.expr = [XPExpression expressionFromString:@"tail(('bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"", [_res stringValue]);
    TDEquals(0, [_res count]);

    self.expr = [XPExpression expressionFromString:@"tail(('foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"bar", [_res stringValue]);
    TDEquals(1, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"tail(('foobar', 'bar', 'baz'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"bar", [[_res itemAt:0] stringValue]);
    TDEqualObjects(@"baz", [[_res itemAt:1] stringValue]);
    TDEquals(2, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"tail((0, 0))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"0", [_res stringValue]);
    TDEquals(1, [_res count]);

    self.expr = [XPExpression expressionFromString:@"tail((number('NaN'), number('NaN')))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"NaN", [_res stringValue]);
    TDEquals(1, [_res count]);
}

@end
