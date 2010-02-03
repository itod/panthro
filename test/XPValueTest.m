//
//  XPValueTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValueTest.h"

@implementation XPValueTest

- (void)testNumberFromString {
    TDEquals(2.0, XPNumberFromString(@"2"));
    TDEquals(2.0, XPNumberFromString(@"2.00"));
    TDEquals(2.0, XPNumberFromString(@"02.00"));

    TDEquals((double)NAN, XPNumberFromString(@"2.0e12"));
    TDEquals((double)NAN, XPNumberFromString(@"1.0E12"));
    TDEquals((double)NAN, XPNumberFromString(@"+1.0"));
}

@end
