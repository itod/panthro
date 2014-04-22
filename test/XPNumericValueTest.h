//
//  XPNumericValueTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPNumericValueTest : SenTestCase
@property (nonatomic, retain) XPNumericValue *n1;
@property (nonatomic, retain) XPNumericValue *n2;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) double res;
@end
