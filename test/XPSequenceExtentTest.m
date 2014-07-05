//
//  XPSequenceExtentTest
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"
#import "XPNodeTypeTest.h"
#import "XPLibxmlDocumentImpl.h"
#import "XPLibxmlNodeImpl.h"
#import "XPPathExpression.h"
#import "XPNodeInfo.h"
#import "XPItem.h"
#import "XPStandaloneContext.h"

#import <libxml/tree.h>

@interface XPSequenceExtentTest : XCTestCase
@property (nonatomic, retain) XPStandaloneContext *env;
@property (nonatomic, assign) xmlNodePtr contextNode;
@property (nonatomic, assign) xmlParserCtxtPtr parserCtx;
@property (nonatomic, retain) XPSequenceValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *pis;
@end

@implementation XPSequenceExtentTest

- (void)setUp {
    [super setUp];
    
    self.ids = @[@"c1", @"c2", @"c3"];
    self.titles = @[@"Chapter 1", @"Chapter 2", @"Chapter 3"];
    self.paras = @[@"Chapter 1 content. ", @"Chapter 2 content.", @"Chapter 3 content."];
    self.comments = @[@" some comment  text "];
    self.pis = @[@"bar='baz'"];
    
    //NSString *str = XPContentsOfFile(@"book.xml");
    NSString *path = XPPathOfFile(@"book.xml");
    
    
    self.parserCtx = xmlNewParserCtxt();
    
    xmlLineNumbersDefault(1);
    
    int record_info = 1;
    xmlSetFeature(_parserCtx, "gather line info", &record_info);
    //    int validate = 1;
    //    xmlSetFeature(_parserCtx, "validate", &validate);
    //XML_PARSE_DTDVALID
    xmlDocPtr doc = xmlCtxtReadFile(_parserCtx, [path UTF8String], NULL, XML_PARSE_NOENT);
    //xmlDocPtr doc = xmlCtxtReadMemory(_parserCtx, [str UTF8String], [str length], NULL, "utf-8", XML_PARSE_NOENT|);
    TDTrue(NULL != doc);
    
    //
    // NOTE: the <book> outermost element is the context node in all tests!!!
    //
    
    xmlNodePtr docEl = xmlFirstElementChild((void *)doc);
    TDTrue(NULL != docEl);
    TDTrue(0 == strcmp((char *)docEl->name, "book"));
    
    self.env = [XPStandaloneContext standaloneContext];
    [_env setValue:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    
    self.contextNode = docEl;
}


- (void)eval:(NSString *)xpathStr {
    TDNotNil(_env);
    NSError *err = nil;
    
    id <XPNodeInfo>ctxNode = [XPLibxmlNodeImpl nodeInfoWithNode:_contextNode parserContext:_parserCtx];
    self.res = [_env execute:xpathStr withContextNode:ctxNode error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    //TDNil(err);
    TDNotNil(_res);
}


- (void)tearDown {
    self.ids = nil;
    self.titles = nil;
    self.paras = nil;
    self.comments = nil;
    self.pis = nil;
    [super tearDown];
}


- (void)testOpen1Comma2Close {
    [self eval:@"(1, 2)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];

    XPValue *val = nil;
    
    val = [enm nextValue];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = [enm nextValue];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpen1Comma2Comma3Close {
    [self eval:@"(1, 2, 3)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = [enm nextValue];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = [enm nextValue];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = [enm nextValue];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterCommaChapterSlashTitleClose {
    [self eval:@"(chapter, chapter/title)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterCommaChapterClose {
    [self eval:@"(chapter, chapter)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testRange1to3 {
    [self eval:@"1 to 3"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    XPValue *val = nil;
    
    val = [enm nextValue];
    TDEqualObjects(@"1", val.stringValue);
    TDEquals(1.0, [val asNumber]);
    
    val = [enm nextValue];
    TDEqualObjects(@"2", val.stringValue);
    TDEquals(2.0, [val asNumber]);
    
    val = [enm nextValue];
    TDEqualObjects(@"3", val.stringValue);
    TDEquals(3.0, [val asNumber]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenClose {
    [self eval:@"()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}

@end
