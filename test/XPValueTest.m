//
//  XPValueTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPValueTest : XCTestCase

@end

@implementation XPValueTest

- (void)testNumberFromString {
    TDEquals(2.0, XPNumberFromString(@"2"));
    TDEquals(2.0, XPNumberFromString(@"2.00"));
    TDEquals(2.0, XPNumberFromString(@"02.00"));

    TDTrue(isnan(XPNumberFromString(@"2.0e12")));
    TDTrue(isnan(XPNumberFromString(@"1.0E12")));
    TDTrue(isnan(XPNumberFromString(@"+1.0")));
}

@end
