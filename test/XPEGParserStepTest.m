//
//  XPEGParserStepTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPEGParserStepTest.h"

@implementation XPEGParserStepTest

- (void)dealloc {
    self.parser = nil;
    [super dealloc];
}


- (void)setUp {
    self.parser = [[[XPEGParser alloc] init] autorelease];
}


- (void)testAncestorAxisNameTestStep {
    NSString *str = @"ancestor::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[ancestor, title]ancestor/::/title^", [a description]);
}


- (void)testAncestorOrSelfAxisNameTestStep {
    NSString *str = @"ancestor-or-self::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[ancestor-or-self, title]ancestor-or-self/::/title^", [a description]);
}


- (void)testAbbreviatedAttrAxisNameTestStep {
    NSString *str = @"@title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[@, title]@/title^", [a description]);
}


- (void)testAttrAxisNameTestStep {
    NSString *str = @"attribute::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[attribute, title]attribute/::/title^", [a description]);
}


- (void)testChildAxisNameTestStep {
    NSString *str = @"child::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[child, title]child/::/title^", [a description]);
}


- (void)testDescendantAxisNameTestStep {
    NSString *str = @"descendant::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[descendant, title]descendant/::/title^", [a description]);
}


- (void)testDescendantOrSelfAxisNameTestStep {
    NSString *str = @"descendant-or-self::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[descendant-or-self, title]descendant-or-self/::/title^", [a description]);
}


- (void)testFollowingAxisNameTestStep {
    NSString *str = @"following::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[following, title]following/::/title^", [a description]);
}


- (void)testFollowingSiblingAxisNameTestStep {
    NSString *str = @"following-sibling::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[following-sibling, title]following-sibling/::/title^", [a description]);
}


- (void)testNamespaceAxisNameTestStep {
    NSString *str = @"namespace::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[namespace, title]namespace/::/title^", [a description]);
}


- (void)testParentAxisNameTestStep {
    NSString *str = @"parent::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[parent, title]parent/::/title^", [a description]);
}


- (void)testPrecedingAxisNameTestStep {
    NSString *str = @"preceding::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[preceding, title]preceding/::/title^", [a description]);
}


- (void)testPrecedingSiblingAxisNameTestStep {
    NSString *str = @"preceding-sibling::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[preceding-sibling, title]preceding-sibling/::/title^", [a description]);
}


- (void)testSelfAxisNameTestStep {
    NSString *str = @"self::title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[self, title]self/::/title^", [a description]);
}


- (void)testImplicitChildAxisNameTestStep {
    NSString *str = @"title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title]title^", [a description]);
}


- (void)testImplicitChildAxisNameTestPredicateAttrStep {
    NSString *str = @"title[@author]";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title, [, @, author, ]]title/[/@/author/]^", [a description]);
}


- (void)testImplicitChildAxisNameTestPredicateAttrEqStrStep {
    NSString *str = @"title[@author='JK Rowling']";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title, [, @, author, =, 'JK Rowling', ]]title/[/@/author/=/'JK Rowling'/]^", [a description]);
}


- (void)testImplicitChildAxisNameTestPredicateNumStep {
    NSString *str = @"title[2]";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title, [, 2, ]]title/[/2/]^", [a description]);
}


- (void)testImplicitChildAxisNameTestPredicatePosEqNumStep {
    NSString *str = @"title[position()=2]";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title, [, position, (, =, 2, ]]title/[/position/(/)/=/2/]^", [a description]);
}


- (void)testImplicitChildAxisNameTestPredicateNumPredicateAttrStep {
    NSString *str = @"title[2][@author]";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[title, [, 2, ], [, @, author, ]]title/[/2/]/[/@/author/]^", [a description]);
}

@synthesize parser;
@end
