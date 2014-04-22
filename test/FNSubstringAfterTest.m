//
//  FNSubstringAfterTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSubstringAfterTest.h"

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
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"345");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('12345', '6')" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('1999/04/01', '/')" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"04/01");
    
    self.expr = [XPExpression expressionFromString:@"substring-after('1999/04/01', '19')" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"99/04/01");
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"substring-after('12345', 2)" inContext:nil error:nil];
    self.res = [expr evaluateAsStringInContext:nil];
    TDEqualObjects(res, @"345");
}

@synthesize expr;
@synthesize fn;
@synthesize res;
@end
