//
//  FNHeadTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPSequenceExtent.h"
#import "XPEmptySequence.h"

@interface FNHeadTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) id res;
@end

@implementation FNHeadTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"head()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"head('1', '2')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    self.expr = [XPExpression expressionFromString:@"head(())" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"", [_res stringValue]);
    TDEquals(0, [_res count]);

    self.expr = [XPExpression expressionFromString:@"head('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"foo", [_res stringValue]);
    TDEquals(1, [_res count]);

    self.expr = [XPExpression expressionFromString:@"head(('bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"bar", [_res stringValue]);
    TDEquals(1, [_res count]);

    self.expr = [XPExpression expressionFromString:@"head(('foobar', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"foobar", [_res stringValue]);
    TDEquals(1, [_res count]);
    
    self.expr = [XPExpression expressionFromString:@"head(0)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"0", [_res stringValue]);
    TDEquals(1, [_res count]);

    self.expr = [XPExpression expressionFromString:@"head(number('NaN'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsSequenceInContext:nil];
    TDEqualObjects(@"NaN", [_res stringValue]);
    TDEquals(1, [_res count]);
}

@end
