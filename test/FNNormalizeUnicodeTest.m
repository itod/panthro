//
//  FNNormalizeUnicodeTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface FNNormalizeUnicodeTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPFunction *fn;
@property (nonatomic, assign) BOOL res;
@end

@implementation FNNormalizeUnicodeTest

- (void)setUp {
    
}


- (void)testEqualsExprNormalizeUnicode {
    //    self.expr = [XPExpression expressionFromString:@"'ü' = normalize-unicode('ü')" inContext:nil error:nil];
    //    self.res = [_expr evaluateAsBooleanInContext:nil];
    //    TDTrue(_res);
    //
    //    self.expr = [XPExpression expressionFromString:@"'ü' = normalize-unicode('ü')" inContext:nil error:nil];
    //    self.res = [_expr evaluateAsBooleanInContext:nil];
    //    TDTrue(_res);
}

@end
