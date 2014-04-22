//
//  XPBooleanValueTest.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPBooleanValueTest : SenTestCase
@property (nonatomic, retain) XPBooleanValue *b1;
@property (nonatomic, retain) XPBooleanValue *b2;
@property (nonatomic, retain) XPBooleanValue *b3;
@property (nonatomic, retain) XPBooleanValue *b4;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) BOOL res;
@end
