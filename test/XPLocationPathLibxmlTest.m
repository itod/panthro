//
//  XPLocationPathLibxmlTest.m
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
#import "XPStandaloneContext.h"

#import <libxml/tree.h>

@interface XPLocationPathLibxmlTest : XCTestCase
@property (nonatomic, retain) XPStandaloneContext *env;
@property (nonatomic, assign) xmlNodePtr contextNode;
@property (nonatomic, assign) xmlParserCtxtPtr parserCtx;
@property (nonatomic, retain) XPNodeSetValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *pis;
@end

@implementation XPLocationPathLibxmlTest

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


- (void)testImplicitChildAxisNameTestChapter {
    [self eval:@"chapter"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];

    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapter {
    [self eval:@"child::chapter"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisStar {
    [self eval:@"*"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisStarPredicateAtId {
    [self eval:@"*[@id]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterSlashTitle {
    [self eval:@"chapter/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterSlashTitle {
    [self eval:@"child::chapter/child::title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate1 {
    [self eval:@"chapter[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate2 {
    [self eval:@"chapter[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate3 {
    [self eval:@"chapter[3]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq1 {
    [self eval:@"chapter[position()=1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq2 {
    [self eval:@"chapter[position()=2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq3 {
    [self eval:@"chapter[position()=3]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateLast {
    [self eval:@"chapter[last()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNeLast {
    [self eval:@"chapter[position()!=last()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNe3 {
    [self eval:@"chapter[position()!=3]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNe0 {
    [self eval:@"chapter[position()!=0]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC1 {
    [self eval:@"chapter[attribute::id='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC2 {
    [self eval:@"chapter[attribute::id='c2']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC3 {
    [self eval:@"chapter[attribute::id='c3']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    [self eval:@"chapter[@id='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    [self eval:@"chapter[@id='c2']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    [self eval:@"chapter[@id='c3']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    [self eval:@"child::chapter[@id='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    [self eval:@"child::chapter[@id='c2']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    [self eval:@"child::chapter[@id='c3']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicateAtIdEqC3SlashPara {
    [self eval:@"chapter[@id='c3']/para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1OrIdEqC3 {
    [self eval:@"chapter[@id='c1' or @id='c3']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfNodeTypeTest {
    [self eval:@"chapter[@id='c1' and self::node()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfStar {
    [self eval:@"chapter[@id='c1' and self::*]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfAttribute {
    [self eval:@"chapter[@id='c1' and self::text()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicateAtIdEqC1 {
    [self eval:@"//chapter[@id='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashPara {
    [self eval:@"//para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashFoobarColonPara {
    [_env declareNamespaceURI:@"bar" forPrefix:@"foobar"];
    [self eval:@"//foobar:para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 1; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"foobar:para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(@"Hello", node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotSlashSlashPara {
    [self eval:@".//para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


/*
NOTE: The location path //para[1] does not mean the same as the location path /descendant::para[1]. 
 The latter selects the first descendant para element; 
 the former selects all descendant para elements that are the first para children of their parents.
*/

- (void)testSlashDescendantParaPredicate1 {
    [self eval:@"/descendant::para[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate1 {
    [self eval:@"(//para)[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2 {
    [self eval:@"(//para)[position()=1 or position()=3][2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2Predicate1 {
    [self eval:@"(//para)[position()=1 or position()=3][2][1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashParaPredicate1 {
    [self eval:@"//para[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaPredicate1ClosePredicate2 {
    [self eval:@"(//para[1])[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenChapterSlashSlashParaPredicate1ClosePredicate2 {
    [self eval:@"(chapter//para[1])[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testAncestorNode {
    [self eval:@"ancestor::node()"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testAncestorOrSelfNode {
    [self eval:@"ancestor-or-self::node()"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testAncestorOrSelfNodePredicate1 {
    // This should match the CONTEXT NODE according to Saxon6.5, NSXML, Saxon9.5HE
    [self eval:@"ancestor-or-self::node()[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenAncestorOrSelfNodeSlashDotClosePredicate1 {
    // This should match the ROOT according to Saxon6.5, NSXML, Saxon9.5HE
    [self eval:@"(ancestor-or-self::node()/.)[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenAncestorOrSelfNodeClosePredicate1 {
    // This should match the ROOT according to Saxon6.5, Saxon9.5HE
    // NSXML gets this wrong!!!!!
    [self eval:@"(ancestor-or-self::node())[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;

    node = [enm nextObject];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterUnionSlashSlashPara {
    [self eval:@"//chapter|//para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextObject];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextObject];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashParaUnionSlashSlashChapter {
    [self eval:@"//para|//chapter"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextObject];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextObject];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashParaUnionSlashSlashChapterSlashAtId {
    [self eval:@"//para|//chapter/@id"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        if (i % 2 == 0) {
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node stringValue]);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate1UnionSlashSlashChapterSlashAtIdPredicateStringDotEqC1 {
    [self eval:@"(//para)[1]|//chapter/@id[string(.)='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[0], [node stringValue]);

    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate1UnionSlashSlashChapterSlashAtIdPredicateStringEqC2 {
    [self eval:@"(//para)[1]|//chapter/@id[string()='c2']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    node = [enm nextObject];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate2UnionSlashSlashChapterSlashAtIdPredicateDotEqC3 {
    [self eval:@"(//para)[2]|//chapter/@id[.='c3']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    node = [enm nextObject];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate2UnionDot {
    [self eval:@"(//para)[2]|."];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDot {
    [self eval:@"."];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlash {
    [self eval:@"/"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionSlash {
    [self eval:@".|/"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionDot {
    [self eval:@".|."];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionOpenSlashSlashParaClose {
    [self eval:@".|(//para)"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionSlashSlashPara {
    [self eval:@".|//para"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenDotUnionSlashSlashParaClosePredicate2 {
    [self eval:@"(.|//para)[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionOpenSlashSlashParaClosePredicate2 {
    [self eval:@".|(//para)[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);

    TDTrue([enm hasMoreObjects]);

    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);

    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionOpenOpenSlashSlashParaClosePredicate2Close {
    [self eval:@".|((//para)[2])"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDTrue([enm hasMoreObjects]);
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotUnionOpenSlashUnionParaPredicate2 {
    [self eval:@".|/|(//para)[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEquals(XPNodeTypeRoot, node.nodeType);

    node = [enm nextObject];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDTrue([enm hasMoreObjects]);
    
    node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate1SlashAtIdEqChapterPredicate1SlashAtId {
    [self eval:@"chapter[1]/@id = chapter[1]/@id"];
    
    TDTrue([_res isKindOfClass:[XPBooleanValue class]]);
    TDTrue([_res asBoolean]);
}


- (void)testChapterPredicate1SlashAtIdNeChapterPredicate1SlashAtId {
    [self eval:@"chapter[1]/@id != chapter[2]/@id"];
    
    TDTrue([_res isKindOfClass:[XPBooleanValue class]]);
    TDTrue([_res asBoolean]);
}


- (void)testChapterSlashAtIdEqChapterPredicate1SlashAtId {
    [self eval:@"chapter/@id = chapter[2]/@id"];
    
    TDTrue([_res isKindOfClass:[XPBooleanValue class]]);
    TDTrue([_res asBoolean]);
}


- (void)testChapterSlashAtIdNeChapterPredicate1SlashAtId {
    [self eval:@"chapter/@id != chapter[2]/@id"];
    
    TDTrue([_res isKindOfClass:[XPBooleanValue class]]);
    TDTrue([_res asBoolean]);
}


- (void)testVarFoo {
    [self eval:@"$foo"];
    
    TDTrue([_res isKindOfClass:[XPStringValue class]]);
    TDEqualObjects(@"hello", [_res asString]);
}


- (void)testChapterPredicate1SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[1]/following-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 1; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate2SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[2]/following-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 2; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[3]/following-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 2; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate2SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[2]/preceding-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate1SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[1]/preceding-sibling::*/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarPredicate1SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[1]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarPredicate2SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[2]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingChapterPredicate2SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::chapter[2]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate2SlashFollowingTitle {
    [self eval:@"chapter[2]/following::title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 2; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate2SlashPrecedingTitle {
    [self eval:@"chapter[2]/preceding::title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingTitle {
    [self eval:@"chapter[3]/preceding::title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 2; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingTitlePredicate1 {
    [self eval:@"chapter[3]/preceding::title[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 1; i < 2; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicate3SlashPrecedingTitlePredicate2 {
    [self eval:@"chapter[3]/preceding::title[2]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithDotCh {
    [self eval:@"/book/chapter[starts-with(., 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterSlashParaPredicateStartsWithDotCh {
    [self eval:@"/book/chapter/para[starts-with(., 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], [node stringValue]);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithStringDotCh {
    [self eval:@"/book/chapter[starts-with(string(.), 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterSlashParaPredicateStartsWithStringDotCh {
    [self eval:@"/book/chapter/para[starts-with(string(.), 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], [node stringValue]);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithTrimSpaceDotCh {
    [self eval:@"/book/chapter[starts-with(trim-space(.), 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterPredicateContainsTrimSpaceDotCh {
    [self eval:@"/book/chapter[contains(trim-space(.), 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashBookSlashChapterPredicateContainsDotCh {
    [self eval:@"/book/chapter[contains(., 'Ch')]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1 {
    [self eval:@"//chapter[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameEqChapter {
    [self eval:@"//chapter[1][name()='chapter']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameDotEqChapter {
    [self eval:@"//chapter[1][name(.)='chapter']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameAtIdEqC1 {
    [self eval:@"//chapter[1][name(@id)='c1']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameAtIdEqId {
    [self eval:@"//chapter[1][name(@id)='id']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateLocalNameAtIdEqId {
    [self eval:@"//chapter[1][local-name(@id)='id']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIEqEmptyStr {
    [self eval:@"//chapter[1][namespace-uri()='']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIAtFooColonBazEqBar {
    [_env declareNamespaceURI:@"bar" forPrefix:@"foobar"];
    [self eval:@"//chapter[1]/@*[namespace-uri(.)='bar']/.."];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpace {
    [self eval:@"//chapter[1]/para[normalize-space() = 'Chapter 1 content.']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpaceDot {
    [self eval:@"//chapter[1]/para[normalize-space(.) = 'Chapter 1 content.']"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashComment {
    [self eval:@"comment()"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeComment, node.nodeType);
    TDEqualObjects(_comments[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashPI {
    [self eval:@"//processing-instruction()"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"foo", node.name);
    TDEquals(XPNodeTypePI, node.nodeType);
    TDEqualObjects(_pis[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashPIFoo {
    [self eval:@"processing-instruction('foo')"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"foo", node.name);
    TDEquals(XPNodeTypePI, node.nodeType);
    TDEqualObjects(_pis[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2 {
    [self eval:@"id('c2')"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC1_C2 {
    [self eval:@"id('c1 c2')"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1SlashSelfNode {
    [self eval:@"id('c2 c1')/self::node()"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1SlashDot {
    [self eval:@"id('c2 c1')/."];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1SlashTitle {
    [self eval:@"id('c2 c1')/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], [node stringValue]);
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1PredicatePosNe3SlashTitle {
    [self eval:@"id('c2 c1')[position()!=3]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], [node stringValue]);
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1 {
    [self eval:@"id('c2 c1')"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1Predicate1 {
    [self eval:@"id('c2 c1')[1]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1PredicateLast {
    [self eval:@"id('c2 c1')[last()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1PredicatePositionNeLast {
    [self eval:@"id('c2 c1')[position()!=last()]"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[[node stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1Predicate1SlashTitle {
    [self eval:@"id('c2 c1')[1]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1Predicate2SlashTitle {
    [self eval:@"id('c2 c1')[2]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testIdC2_C1PredicateLastSlashTitle {
    [self eval:@"id('c2 c1')[last()]/title"];
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextObject];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}

@end
