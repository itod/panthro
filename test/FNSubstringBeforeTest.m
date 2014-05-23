//
//  FNSubstringBeforeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNSubstringBeforeTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) NSString *res;
@end

@implementation FNSubstringBeforeTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"substring-before('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-before('1', '2', '3', '4')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-before()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', '2')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', '6')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '/')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1999");
    
    self.expr = [XPExpression expressionFromString:@"substring-before('1999/04/01', '19')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"substring-before('12345', 2)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"1");
}



- (void)testEqualsExprSubstringBefore {
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'b') = 'a'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'a') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-before('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
