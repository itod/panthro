//
//  XPFlworTest
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

@interface XPFlworTest : XCTestCase
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

@implementation XPFlworTest

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
    [_env setItem:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    [_env setItem:[XPStringValue stringValueWithString:@"bye"] forVariable:@"bar"];
    
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


- (void)testOpenForCInChapterReturnC {
    [self eval:@"for $c in chapter return $c"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenForCInChapterLetIdEqCSlashIdWhereIdNeC2ReturnC {
    [self eval:@"for $c in chapter let $id := $c/@id where $id != 'c2' return $id"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEqualObjects(_ids[0], node.stringValue);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEqualObjects(_ids[2], node.stringValue);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenForCInChapterLetIdEqCSlashIdWhereIdNeC2OrderByIdDescendingReturnC {
    [self eval:@"for $c in chapter let $id := $c/@id where $id != 'c2' order by $id descending return $id"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEqualObjects(_ids[2], node.stringValue);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEqualObjects(_ids[0], node.stringValue);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenForCInChapterLetIdEqCSlashIdCommaTxtEqStringOpenCCloseWhereIdNeC1OrderByIdDescendingReturnC {
    [self eval:@"for $c in chapter, $p in $c/para let $id := $c/@id, $txt := string($p) where $id != 'c1' order by $id descending return $txt"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPItem>item = nil;
    
    item = [enm nextItem];
    TDEqualObjects(_paras[2], item.stringValue);
    
    item = [enm nextItem];
    TDEqualObjects(_paras[1], item.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenForCInChapterLetIdEqCSlashIdCommaTxtEqStringOpenCCloseWhereIdNeC3OrderByIdAscendingReturnC {
    [self eval:@"for $c in chapter, $p in $c/para let $id := $c/@id, $txt := string($p) where $id != 'c3' order by $id ascending return $txt"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPItem>item = nil;
    
    item = [enm nextItem];
    TDEqualObjects(_paras[0], item.stringValue);
    
    item = [enm nextItem];
    TDEqualObjects(_paras[1], item.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSwitch123_1 {
    [self eval:@"switch (1) case 1 return 'one' case 2 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"one", [_res stringValue]);
}


- (void)testSwitch123_2 {
    [self eval:@"switch (2) case 1 return 'one' case 2 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"two", [_res stringValue]);
}


- (void)testSwitch123_3 {
    [self eval:@"switch (3) case 1 return 'one' case 2 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"three", [_res stringValue]);
}


- (void)testSwitch123_4 {
    [self eval:@"switch (4) case 1 return 'one' case 2 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"unknown", [_res stringValue]);
}


- (void)testSwitch1253_1 {
    [self eval:@"switch (1) case 1 return 'one' case 2 case 2.5 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"one", [_res stringValue]);
}


- (void)testSwitch1253_2 {
    [self eval:@"switch (2) case 1 return 'one' case 2 case 2.5 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"two", [_res stringValue]);
}


- (void)testSwitch1253_25 {
    [self eval:@"switch (2.5) case 1 return 'one' case 2 case 2.5 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"two", [_res stringValue]);
}


- (void)testSwitch1253_3 {
    [self eval:@"switch (3) case 1 return 'one' case 2 case 2.5 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"three", [_res stringValue]);
}


- (void)testSwitch1253_4 {
    [self eval:@"switch (4) case 1 return 'one' case 2 case 2.5 return 'two' case 3 return 'three' default return 'unknown'"];
    
    TDEqualObjects(@"unknown", [_res stringValue]);
}

@end