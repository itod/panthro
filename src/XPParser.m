//
//  XPParser.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/16/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPParser.h>
#import <XPath/XPath.h>
#import <ParseKit/ParseKit.h>
#import "XPAssembler.h"

@interface XPParser ()
@property (nonatomic, retain) PKParser *parser;
@property (nonatomic, retain) XPAssembler *assembler;
@end

@implementation XPParser

- (id)init {
    if (self = [super init]) {
        self.assembler = [[[XPAssembler alloc] init] autorelease];
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xpath1_0" ofType:@"grammar"];
        NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        self.parser = [[PKParserFactory factory] parserFromGrammar:g assembler:assembler error:nil];
        NSAssert(parser, @"");
}
    return self;
}


- (void)dealloc {
    self.parser = nil;
    self.assembler = nil;
    [super dealloc];
}


- (XPExpression *)parseExpression:(NSString *)s inContext:(id <XPStaticContext>)env {
    XPExpression *res = [parser parse:s error:nil];
    return res;
}

@synthesize parser;
@synthesize assembler;
@end
