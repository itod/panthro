//
//  FNSubstringAfterTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNSubstringAfterTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, retain) NSString *res;
@end

@implementation FNSubstringAfterTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"substring-after('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-after('1', '2', '3', '4')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"substring-after()" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"substring-after('12345', '2')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"345");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('12345', '6')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('1999/04/01', '/')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"04/01");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('1999/04/01', '19')" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"99/04/01");
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"substring-after('12345', 2)" inContext:nil error:nil];
    self.res = [_expr evaluateAsStringInContext:nil];
    TDEqualObjects(_res, @"345");
}


- (void)testEqualsExprSubstringAfter {
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'b') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'a') = 'b'" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr = [XPExpression expressionFromString:@"substring-after('ab', 'c') = ''" inContext:nil error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
}

@end
