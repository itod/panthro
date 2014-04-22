//
//  PKTestScaffold.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

#define RUN_ALL_TEST_CASES 1
#define SOLO_TEST_CASE @"XPEGParserStepAxisTest"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface SenTestSuite (XPAdditions)
- (void)addSuitesForClassNames:(NSArray *)classNames;
@end

SenTestSuite *TDSoloTestSuite() {
    SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"Solo Test Suite"];
    
    NSArray *classNames = [NSArray arrayWithObject:SOLO_TEST_CASE];
    
    [suite addSuitesForClassNames:classNames];
    return suite;
}


SenTestSuite *XPathTestSuite() {
    SenTestSuite *suite = [SenTestSuite testSuiteWithName:@"XPath Test Suite"];
    
    NSArray *classNames = [NSArray arrayWithObjects:
                           @"XPBooleanValue",
                           nil];
    
    [suite addSuitesForClassNames:classNames];
    return suite;
}

@implementation SenTestSuite (XPAdditions)

+ (id)testSuiteForBundlePath:(NSString *)bundlePath {
    SenTestSuite *suite = nil;
    
#if RUN_ALL_TEST_CASES
    suite = [self defaultTestSuite];
#else
    suite = [SenTestSuite testSuiteWithName:@"My Tests"]; 
//    [suite addTest:[self XPathTestSuite]];
    [suite addTest:TDSoloTestSuite()];
#endif
    
    return suite;
}


- (void)addSuitesForClassNames:(NSArray *)classNames {
    for (NSString *className in classNames) {
        SenTestSuite *suite = [SenTestSuite testSuiteForTestCaseWithName:className];
        [self addTest:suite];
    }
}

#pragma clang diagnostic pop

@end