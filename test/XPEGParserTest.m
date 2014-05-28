//
//  XPEGParserTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "XPEGParser.h"

#define TD_EMIT 1

static PGParserFactory *factory;
static PGRootNode *root;
static PGParserGenVisitor *visitor;
static XPEGParser *parser;

@interface XPEGParserTest : XCTestCase
@end

@implementation XPEGParserTest

+ (void)setUp {
    factory = [[PGParserFactory factory] retain];
    factory.collectTokenKinds = YES;
    
    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:self] pathForResource:@"peg_xpath1_0" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    root = [(id)[factory ASTFromGrammar:g error:&err] retain];
    root.grammarName = @"XPEG";
    
    visitor = [[PGParserGenVisitor alloc] init];
    visitor.enableMemoization = YES;
    visitor.delegatePreMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnNone;
    visitor.delegatePostMatchCallbacksOn = PGParserFactoryDelegateCallbacksOnAll;
    
    [root visit:visitor];
    
#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/src/XPEGParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
    
    path = [[NSString stringWithFormat:@"%s/src/XPEGParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
    
    parser = [[XPEGParser alloc] initWithDelegate:nil];
}

+ (void)tearDown {
    [factory release];
    [root release];
    [visitor release];
    [parser release];
}

- (void)testFoo {
    //TDTrue(0);
}

@end
