//
//  XPEGParserLocationPathTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPEGParserLocationPathTest.h"

@implementation XPEGParserLocationPathTest

- (void)dealloc {
    self.parser = nil;
    [super dealloc];
}


- (void)setUp {
    self.parser = [[[XPEGParser alloc] init] autorelease];
}


- (void)testAbsolute2StepImplicitChildAxisNameTestStep {
    NSString *str = @"//book/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[//, book, /, title]///book///title^", [a description]);
}


- (void)testAbsoluteAbbreviated1StepImplicitChildAxisNameTestStep {
    NSString *str = @"//book";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[//, book]///book^", [a description]);
}


- (void)testRelativeAbbreviated2StepImplicitChildAxisNameTestStep {
    NSString *str = @"books//title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[books, //, title]books////title^", [a description]);
}


- (void)testRelativeAbbreviated2StepImplicitChildAxisNameTestStepStar {
    NSString *str = @"books//*";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[books, //, *]books////*^", [a description]);
}


- (void)testRelativeAbbreviated3StepImplicitChildAxisNameTestStep {
    NSString *str = @"books//*/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[books, //, *, /, title]books////*///title^", [a description]);
}


- (void)testAbsolute1StepImplicitChildAxisNameTestStep {
    NSString *str = @"/book";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[/, book]//book^", [a description]);
}


- (void)testRelative2StepImplicitChildAxisNameTestStep {
    NSString *str = @"book/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[book, /, title]book///title^", [a description]);
}


- (void)testRelative2StepImplicitChildAxisNameTestPredicateNumStep {
    NSString *str = @"book[2]/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[book, [, 2, ], /, title]book/[/2/]///title^", [a description]);
}


- (void)testRelative2StepImplicitChildAxisNameTestPredicateBoolStep {
    NSString *str = @"book[not(preceding-sibling::book/@author=@author)]/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[book, [, not, (, preceding-sibling, book, /, @, author, =, @, author, ], /, title]book/[/not/(/preceding-sibling/::/book///@/author/=/@/author/)/]///title^", [a description]);
}


- (void)testRelative3StepImplicitChildAxisNameTestStep {
    NSString *str = @"books/book/title";
    NSError *err = nil;
    id a = [parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[books, /, book, /, title]books///book///title^", [a description]);
}

@synthesize parser;
@end
