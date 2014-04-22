//
//  XPStringValueTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPStringValueTest : SenTestCase
@property (nonatomic, retain) XPStringValue *s1;
@property (nonatomic, retain) XPStringValue *s2;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end
