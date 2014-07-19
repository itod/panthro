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
@property (nonatomic, retain) XPSequenceValue *res;
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
    [_env setItem:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    
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
    
    id <XPSequenceEnumeration>enm = [_res enumerate];

    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestChapter {
    [self eval:@"child::chapter"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisStar {
    [self eval:@"*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisStarPredicateAtId {
    [self eval:@"*[@id]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterSlashTitle {
    [self eval:@"chapter/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestChapterSlashTitle {
    [self eval:@"child::chapter/child::title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate1 {
    [self eval:@"chapter[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate2 {
    [self eval:@"chapter[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate3 {
    [self eval:@"chapter[3]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq1 {
    [self eval:@"chapter[position()=1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq2 {
    [self eval:@"chapter[position()=2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq3 {
    [self eval:@"chapter[position()=3]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateLast {
    [self eval:@"chapter[last()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNeLast {
    [self eval:@"chapter[position()!=last()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNe3 {
    [self eval:@"chapter[position()!=3]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNe0 {
    [self eval:@"chapter[position()!=0]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC1 {
    [self eval:@"chapter[attribute::id='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC2 {
    [self eval:@"chapter[attribute::id='c2']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC3 {
    [self eval:@"chapter[attribute::id='c3']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    [self eval:@"chapter[@id='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    [self eval:@"chapter[@id='c2']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    [self eval:@"chapter[@id='c3']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    [self eval:@"child::chapter[@id='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    [self eval:@"child::chapter[@id='c2']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    [self eval:@"child::chapter[@id='c3']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicateAtIdEqC3SlashPara {
    [self eval:@"chapter[@id='c3']/para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1OrIdEqC3 {
    [self eval:@"chapter[@id='c1' or @id='c3']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfNodeTypeTest {
    [self eval:@"chapter[@id='c1' and self::node()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfStar {
    [self eval:@"chapter[@id='c1' and self::*]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfAttribute {
    [self eval:@"chapter[@id='c1' and self::text()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicateAtIdEqC1 {
    [self eval:@"//chapter[@id='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashPara {
    [self eval:@"//para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashFoobarColonPara {
    [_env declareNamespaceURI:@"bar" forPrefix:@"foobar"];
    [self eval:@"//foobar:para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 1; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"foobar:para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(@"Hello", node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotSlashSlashPara {
    [self eval:@".//para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


/*
NOTE: The location path //para[1] does not mean the same as the location path /descendant::para[1]. 
 The latter selects the first descendant para element; 
 the former selects all descendant para elements that are the first para children of their parents.
*/

- (void)testSlashDescendantParaPredicate1 {
    [self eval:@"/descendant::para[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate1 {
    [self eval:@"(//para)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2 {
    [self eval:@"(//para)[position()=1 or position()=3][2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2Predicate1 {
    [self eval:@"(//para)[position()=1 or position()=3][2][1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashParaPredicate1 {
    [self eval:@"//para[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaPredicate1ClosePredicate2 {
    [self eval:@"(//para[1])[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterSlashSlashParaPredicate1ClosePredicate2 {
    [self eval:@"(chapter//para[1])[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorNode {
    [self eval:@"ancestor::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorOrSelfNode {
    [self eval:@"ancestor-or-self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorOrSelfNodeSlashDot {
    [self eval:@"ancestor-or-self::node()/."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorOrSelfNodePredicate1 {
    // This should match the CONTEXT NODE according to Saxon6.5, NSXML, Saxon9.5HE
    [self eval:@"ancestor-or-self::node()[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenAncestorOrSelfNodeSlashDotClosePredicate1 {
    // This should match the ROOT according to Saxon6.5, NSXML, Saxon9.5HE
    [self eval:@"(ancestor-or-self::node()/.)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenAncestorOrSelfNodeClosePredicate1 {
    // This should match the ROOT according to Saxon6.5, Saxon9.5HE
    // NSXML gets this wrong!!!!!
    [self eval:@"(ancestor-or-self::node())[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;

    node = [enm nextNodeInfo];
    TDEqualObjects([XPLibxmlDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPipeSlashSlashPara {
    [self eval:@"//chapter|//para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashOpenChapterPipeParaClose {
    [self eval:@"//(chapter|para)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterUnionSlashSlashPara {
    [self eval:@"//chapter union //para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashParaPipeSlashSlashChapter {
    [self eval:@"//para|//chapter"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashOpenParaPipeChapterClose {
    [self eval:@"//(para|chapter)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"chapter", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node attributeValueForURI:nil localName:@"id"]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashParaPipeSlashSlashChapterSlashAtId {
    [self eval:@"//para|//chapter/@id"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashOpenParaPipeChapterSlashAtIdClose {
    [self eval:@"//(para|chapter/@id)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashParaUnionSlashSlashChapterSlashAtId {
    [self eval:@"//para union //chapter/@id"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleClose {
    [self eval:@"chapter/(para|title)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"title", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenTitlePipeParaClose {
    [self eval:@"chapter/(title|para)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"title", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenTitlePipeParaCloseSlashTextOpenClose {
    [self eval:@"chapter/(title|para)/text()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"", node.name);
            TDEquals(XPNodeTypeText, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"", node.name);
            TDEquals(XPNodeTypeText, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleCloseSlashTextOpenClose {
    [self eval:@"chapter/(para|title)/text()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"", node.name);
            TDEquals(XPNodeTypeText, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"", node.name);
            TDEquals(XPNodeTypeText, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleClosePred1 {
    [self eval:@"chapter/(para|title)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleClosePred1SlashTextOpenClose {
    [self eval:@"chapter/(para|title)[1]/text()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"", node.name);
        TDEquals(XPNodeTypeText, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPred1PipeTitlePred1Close {
    [self eval:@"chapter/(para[1]|title[1])"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"title", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenStarPred1PipeStarPred2Close {
    [self eval:@"chapter/(*[1]|*[2])"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger titleIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        if (i % 2 == 0) {
            TDEqualObjects(@"title", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_titles[titleIdx++], node.stringValue);
        } else {
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenStarPred2ExceptOpenSlashSlashParaPred3Close {
    [self eval:@"chapter/(*[2] except (//para)[3])"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenStarPred2ExceptOpenSlashSlashParaPred3CloseSlashTextOpenClose {
    [self eval:@"chapter/(*[2] except (//para)[3])/text()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeText, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeText, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPred2PipeTitlePred3Close {
    [self eval:@"chapter/(para[2]|title[3])"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];

    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleClosePred2 {
    [self eval:@"chapter/(para|title)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashOpenParaPipeTitleClosePred2SlashTextOpenClose {
    [self eval:@"chapter/(para|title)[2]/text()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"", node.name);
        TDEquals(XPNodeTypeText, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashIdOpenCh1CloseSlashTitle {
    [self eval:@"/book/id('c1')/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];

    id <XPNodeInfo>node = [enm nextNodeInfo];

    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate1PipeSlashSlashChapterSlashAtIdPredicateStringDotEqC1 {
    [self eval:@"(//para)[1]|//chapter/@id[string(.)='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[0], node.stringValue);

    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate1PipeSlashSlashChapterSlashAtIdPredicateStringEqC2 {
    [self eval:@"(//para)[1]|//chapter/@id[string()='c2']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate2PipeSlashSlashChapterSlashAtIdPredicateDotEqC3 {
    [self eval:@"(//para)[2]|//chapter/@id[.='c3']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[2], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate2PipeDot {
    [self eval:@"(//para)[2]|."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDot {
    [self eval:@"."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlash {
    [self eval:@"/"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeSlash {
    [self eval:@".|/"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeDot {
    [self eval:@".|."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeOpenSlashSlashParaClose {
    [self eval:@".|(//para)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeSlashSlashPara {
    [self eval:@".|//para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenDotPipeSlashSlashParaClosePredicate2 {
    [self eval:@"(.|//para)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeOpenSlashSlashParaClosePredicate2 {
    [self eval:@".|(//para)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);

    TDTrue([enm hasMoreItems]);

    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);

    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeOpenOpenSlashSlashParaClosePredicate2Close {
    [self eval:@".|((//para)[2])"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDTrue([enm hasMoreItems]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotPipeOpenSlashPipeParaPredicate2 {
    [self eval:@".|/|(//para)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEquals(XPNodeTypeRoot, node.nodeType);

    node = [enm nextNodeInfo];
    TDEqualObjects(@"book", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDTrue([enm hasMoreItems]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
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
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 1; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate2SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[2]/following-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 2; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[3]/following-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 2; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate2SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[2]/preceding-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate1SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[1]/preceding-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarPredicate1SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[1]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingStarPredicate2SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[2]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingSiblingChapterPredicate2SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::chapter[2]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate2SlashFollowingTitle {
    [self eval:@"chapter[2]/following::title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 2; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate2SlashPrecedingTitle {
    [self eval:@"chapter[2]/preceding::title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingTitle {
    [self eval:@"chapter[3]/preceding::title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 2; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingTitlePredicate1 {
    [self eval:@"chapter[3]/preceding::title[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 1; i < 2; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterPredicate3SlashPrecedingTitlePredicate2 {
    [self eval:@"chapter[3]/preceding::title[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 1; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithDotCh {
    [self eval:@"/book/chapter[starts-with(., 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterSlashParaPredicateStartsWithDotCh {
    [self eval:@"/book/chapter/para[starts-with(., 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithStringDotCh {
    [self eval:@"/book/chapter[starts-with(string(.), 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterSlashParaPredicateStartsWithStringDotCh {
    [self eval:@"/book/chapter/para[starts-with(string(.), 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterPredicateStartsWithTrimSpaceDotCh {
    [self eval:@"/book/chapter[starts-with(trim-space(.), 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterPredicateContainsTrimSpaceDotCh {
    [self eval:@"/book/chapter[contains(trim-space(.), 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterPredicateContainsDotCh {
    [self eval:@"/book/chapter[contains(., 'Ch')]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[i]]);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1 {
    [self eval:@"//chapter[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameEqChapter {
    [self eval:@"//chapter[1][name()='chapter']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameDotEqChapter {
    [self eval:@"//chapter[1][name(.)='chapter']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameAtIdEqC1 {
    [self eval:@"//chapter[1][name(@id)='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameAtIdEqId {
    [self eval:@"//chapter[1][name(@id)='id']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateLocalNameAtIdEqId {
    [self eval:@"//chapter[1][local-name(@id)='id']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIEqEmptyStr {
    [self eval:@"//chapter[1][namespace-uri()='']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIAtFooColonBazEqBar {
    [_env declareNamespaceURI:@"bar" forPrefix:@"foobar"];
    [self eval:@"//chapter[1]/@*[namespace-uri(.)='bar']/.."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpace {
    [self eval:@"//chapter[1]/para[normalize-space() = 'Chapter 1 content.']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([node.stringValue hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpaceDot {
    [self eval:@"//chapter[1]/para[normalize-space(.) = 'Chapter 1 content.']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([node.stringValue hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashComment {
    [self eval:@"comment()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeComment, node.nodeType);
    TDEqualObjects(_comments[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashPI {
    [self eval:@"//processing-instruction()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"foo", node.name);
    TDEquals(XPNodeTypePI, node.nodeType);
    TDEqualObjects(_pis[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashPIFoo {
    [self eval:@"processing-instruction('foo')"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"foo", node.name);
    TDEquals(XPNodeTypePI, node.nodeType);
    TDEqualObjects(_pis[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2 {
    [self eval:@"id('c2')"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC1_C2 {
    [self eval:@"id('c1 c2')"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1SlashSelfNode {
    [self eval:@"id('c2 c1')/self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1SlashDot {
    [self eval:@"id('c2 c1')/."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1SlashTitle {
    [self eval:@"id('c2 c1')/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1PredicatePosNe3SlashTitle {
    [self eval:@"id('c2 c1')[position()!=3]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1 {
    [self eval:@"id('c2 c1')"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1Predicate1 {
    [self eval:@"id('c2 c1')[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1PredicateLast {
    [self eval:@"id('c2 c1')[last()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[1]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1PredicatePositionNeLast {
    [self eval:@"id('c2 c1')[position()!=last()]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1Predicate1SlashTitle {
    [self eval:@"id('c2 c1')[1]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1Predicate2SlashTitle {
    [self eval:@"id('c2 c1')[2]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testIdC2_C1PredicateLastSlashTitle {
    [self eval:@"id('c2 c1')[last()]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashNamespaceAxisStar {
    [self eval:@"/book/namespace::*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"foobar", node.name);
    TDEquals(XPNodeTypeNamespace, node.nodeType);
    TDEqualObjects(@"bar", node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"google", node.name);
    TDEquals(XPNodeTypeNamespace, node.nodeType);
    TDEqualObjects(@"www.google.com", node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashBookSlashChapterSlashNamespaceAxisStar {
    [self eval:@"/book/chapter/namespace::*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"google", node.name);
    TDEquals(XPNodeTypeNamespace, node.nodeType);
    TDEqualObjects(@"www.google.com", node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"foobar", node.name);
    TDEquals(XPNodeTypeNamespace, node.nodeType);
    TDEqualObjects(@"bar", node.stringValue);
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"apple", node.name);
    TDEquals(XPNodeTypeNamespace, node.nodeType);
    TDEqualObjects(@"www.apple.com", node.stringValue);
    
    for (NSUInteger i = 0; i < 2; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"google", node.name);
        TDEquals(XPNodeTypeNamespace, node.nodeType);
        TDEqualObjects(@"www.google.com", node.stringValue);
        
        node = [enm nextNodeInfo];
        TDEqualObjects(@"foobar", node.name);
        TDEquals(XPNodeTypeNamespace, node.nodeType);
        TDEqualObjects(@"bar", node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashDiv {
    [self eval:@"//div"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"div", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(@"", node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testEarlyBail {
    [self eval:@"/book/foo/bar"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisStarColonChapter {
    // this is XPath 2.0
    [self eval:@"*:chapter"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDistinctWhenResultNodeSetWouldIncludeExactlyOneNodeTwice {
    [self eval:@"//chapter[@id='c2']/*/parent::*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEqualObjects(@"c2", [node attributeValueForURI:nil localName:@"id"]);
    TDEqualObjects(@"c2", [node attributeValueForURI:@"" localName:@"id"]);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashDotDot {
    [self eval:@"/.."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashAtStarDescendantOrSelfNode {
    [self eval:@"chapter/@id/descendant-or-self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"id", node.name);
        TDEquals(XPNodeTypeAttribute, node.nodeType);
        TDEqualObjects(_ids[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashAtIdChildNode {
    [self eval:@"chapter/@id/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashAtStarChildNode {
    [self eval:@"chapter/@*/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashAttributeStarChildNode {
    [self eval:@"chapter/attribute::*/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashAttributeNodeChildNode {
    [self eval:@"chapter/attribute::node()/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashNamespaceStarChildNode {
    [self eval:@"chapter/namespace::*/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashNamespaceNodeChildNode {
    [self eval:@"chapter/namespace::node()/child::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashAtStarSlashSelfNode {
    [self eval:@"//@id/self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    for (NSUInteger i = 0; i < 3; ++i) {
        node = [enm nextNodeInfo];
        TDEqualObjects(@"id", node.name);
        TDEquals(XPNodeTypeAttribute, node.nodeType);
        TDEqualObjects(_ids[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashAtStarSlashSelfStar {
    [self eval:@"//@*/self::*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashNamespaceStarSlashSelfNode {
    [self eval:@"//namespace::*/self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDTrue([enm hasMoreItems]);
}


- (void)testSlashSlashNamespaceStarSlashSelfStar {
    [self eval:@"//namespace::*/self::*"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleExceptChapterSlashTitlePredicate1 {
    [self eval:@"chapter/title except chapter[1]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 1; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleExceptChapterSlashTitlePredicate3 {
    [self eval:@"chapter/title except chapter[3]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 2; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleExceptChapterSlashTitle {
    [self eval:@"chapter/title except chapter/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];

    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterSlashTitleClosePredicate2ExceptOpenChapterSlashTitleCloasePredicate1 {
    [self eval:@"(chapter/title)[2] except (chapter/title)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 1; i < 2; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterSlashTitleClosePredicate2ExceptOpenChapterSlashTitleCloasePredicate2 {
    [self eval:@"(chapter/title)[2] except (chapter/title)[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleIntersectChapterPredicate1SlashTitle {
    [self eval:@"chapter/title intersect chapter[1]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 1; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleIntersectChapterPredicate2SlashTitle {
    [self eval:@"chapter/title intersect chapter[2]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 1; i < 2; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleIntersectChapterPredicate3SlashTitle {
    [self eval:@"chapter/title intersect chapter[3]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 2; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testChapterSlashTitleIntersectChapterSlashTitle {
    [self eval:@"chapter/title intersect chapter/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextNodeInfo];
        TDEqualObjects(@"title", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_titles[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterIntersectSlashSlashPara {
    [self eval:@"//chapter intersect //para"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashTitleClosePredLastOpenCloseSpaceMinusSpace1 {
    [self eval:@"(//title)[last() - 1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashTitleClosePredLastOpenCloseSpaceMinus1 {
    [self eval:@"(//title)[last() -1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashTitleClosePredLastOpenCloseMinusSpace1 {
    [self eval:@"(//title)[last()- 1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashTitleClosePredLastOpenCloseMinus1 {
    [self eval:@"(//title)[last()-1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}

@end
