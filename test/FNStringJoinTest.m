//
//  FNStringJoinTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNStringJoinTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) NSString *res;
@end

@implementation FNStringJoinTest

- (void)setUp {

}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"string-join()" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"string-join('foo', 'bar', 'baz')" inContext:[XPStandaloneContext standaloneContext] error:&err];
    TDNotNil(err);
}


- (void)testEmptySeparator {
    self.expr = [XPExpression expressionFromString:@"string-join('foo', '')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");

    self.expr = [XPExpression expressionFromString:@"string-join(('foo'), '')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");

    self.expr = [XPExpression expressionFromString:@"string-join(('foo', 'bar'), '')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foobar");
}


- (void)testNoSeparator {
    self.expr = [XPExpression expressionFromString:@"string-join('foo')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");
    
    self.expr = [XPExpression expressionFromString:@"string-join(('foo'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");
    
    self.expr = [XPExpression expressionFromString:@"string-join(('foo', 'bar'))" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foobar");
}


- (void)testSeparator {
    self.expr = [XPExpression expressionFromString:@"string-join('foo', ':')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");
    
    self.expr = [XPExpression expressionFromString:@"string-join(('foo'), ':')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo");
    
    self.expr = [XPExpression expressionFromString:@"string-join(('foo', 'bar'), ':')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo:bar");
    
    self.expr = [XPExpression expressionFromString:@"string-join(('foo', 'bar', 'baz'), ',')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"foo,bar,baz");
}


- (void)testEmptyList {
    self.expr = [XPExpression expressionFromString:@"string-join((), ',')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
    
    self.expr = [XPExpression expressionFromString:@"string-join('', ',')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
    
    self.expr = [XPExpression expressionFromString:@"string-join((''), ',')" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
}

@end
