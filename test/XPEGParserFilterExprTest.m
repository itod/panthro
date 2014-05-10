//
//  XPEGParserFilterExprTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPEGParserFilterExprTest : XCTestCase
@property (nonatomic, retain) XPEGParser *parser;
@end

@implementation XPEGParserFilterExprTest

- (void)dealloc {
    self.parser = nil;
    [super dealloc];
}


- (void)setUp {
    self.parser = [[[XPEGParser alloc] init] autorelease];
}


- (void)testBooleanFunction {
    NSString *str = @"boolean(1)";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[boolean, (, 1]boolean/(/1/)^", [a description]);
}


- (void)testTrueLiteral {
    NSString *str = @"true()";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[true]true/(/)^", [a description]);
}


- (void)testVariable {
    NSString *str = @"$foo";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[$, foo]$/foo^", [a description]);
}


- (void)testVariable1StepRelativePath {
    NSString *str = @"$foo/price";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[$, foo, /, price]$/foo///price^", [a description]);
}


- (void)testVariable1StepAbsoluteAbbreviatedPath {
    NSString *str = @"$foo//price";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[$, foo, //, price]$/foo////price^", [a description]);
}


- (void)testFunc1StepAbsoluteAbbreviatedPath {
    NSString *str = @"foo()//price";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[foo, (, //, price]foo/(/)////price^", [a description]);
}


- (void)testFunc1StepAbsolutePath {
    NSString *str = @"foo()/price";
    NSError *err = nil;
    id a = [_parser parseString:str error:&err];
    
    TDNil(err);
    TDNotNil(a);
    
    TDEqualObjects(@"[foo, (, /, price]foo/(/)///price^", [a description]);
}

@end
