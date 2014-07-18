//
//  XPLocationPathTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"
#import "XPNodeTypeTest.h"
#import "XPNSXMLDocumentImpl.h"
#import "XPNSXMLNodeImpl.h"
#import "XPPathExpression.h"
#import "XPNodeInfo.h"
#import "XPStandaloneContext.h"

@interface XPLocationPathNSXMLTest : XCTestCase
@property (nonatomic, retain) XPStandaloneContext *env;
@property (nonatomic, retain) NSXMLNode *contextNode;
@property (nonatomic, retain) XPSequenceValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@property (nonatomic, retain) NSArray *comments;
@end

@implementation XPLocationPathNSXMLTest

- (void)setUp {
    [super setUp];

    self.ids = @[@"c1", @"c2", @"c3"];
    self.titles = @[@"Chapter 1", @"Chapter 2", @"Chapter 3"];
    self.paras = @[@"Chapter 1 content. ", @"Chapter 2 content.", @"Chapter 3 content."];
    self.comments = @[@" some comment  text "];

    NSString *str = XPContentsOfFile(@"book.xml");
    NSError *err = nil;
    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:str options:0 error:&err] autorelease];
    TDNotNil(doc);
    TDNil(err);
    
    //
    // NOTE: the <book> outermost element is the context node in all tests!!!
    //
    
    NSXMLNode *docEl = [doc rootElement];
    TDNotNil(docEl);
    
    self.env = [XPStandaloneContext standaloneContext];
    [_env setItem:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    
    self.contextNode = docEl;
}


- (void)eval:(NSString *)xpathStr {
    TDNotNil(_env);
    NSError *err = nil;
    
    id <XPNodeInfo>ctxNode = [XPNSXMLNodeImpl nodeInfoWithNode:_contextNode];
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
    TDEqualObjects(_paras[2], [node stringValue]);
    
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


- (void)testSlashSlashCapterPredicateAtIdEqC1 {
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
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate1 {
    [self eval:@"(//para)[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2 {
    [self eval:@"(//para)[position()=1 or position()=3][2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2Predicate1 {
    [self eval:@"(//para)[position()=1 or position()=3][2][1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
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
    TDEqualObjects(_paras[1], [node stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenChapterSlashSlashParaPredicate1ClosePredicate2 {
    [self eval:@"(chapter//para[1])[2]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[1], [node stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorNode {
    [self eval:@"ancestor::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects([XPNSXMLDocumentImpl class], [node class]);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAncestorOrSelfNode {
    [self eval:@"ancestor-or-self::node()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects([XPNSXMLDocumentImpl class], [node class]);
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
    TDEqualObjects([XPNSXMLDocumentImpl class], [node class]);
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
    TDEqualObjects([XPNSXMLDocumentImpl class], [node class]);
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


- (void)testSlashSlashParaPipeSlashSlashChapterSlashAtId {
    [self eval:@"//para|//chapter/@id"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    NSUInteger chIdx = 0;
    NSUInteger paraIdx = 0;
    for (NSUInteger i = 0; i < 6; ++i) {
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node stringValue]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
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
        if (i % 2 == 0) {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"id", node.name);
            TDEquals(XPNodeTypeAttribute, node.nodeType);
            TDEqualObjects(_ids[chIdx++], [node stringValue]);
        } else {
            id <XPNodeInfo>node = [enm nextNodeInfo];
            TDEqualObjects(@"para", node.name);
            TDEquals(XPNodeTypeElement, node.nodeType);
            TDEqualObjects(_paras[paraIdx++], node.stringValue);
        }
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenSlashSlashParaClosePredicate1PipeSlashSlashChapterSlashAtIdPredicateStringDotEqC1 {
    [self eval:@"(//para)[1]|//chapter/@id[string(.)='c1']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"id", node.name);
    TDEquals(XPNodeTypeAttribute, node.nodeType);
    TDEqualObjects(_ids[0], [node stringValue]);

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
    TDEqualObjects(_ids[1], [node stringValue]);
    
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
    TDEqualObjects(_ids[2], [node stringValue]);
    
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


- (void)testCapterPredicate1SlashFollowingSiblingStarSlashTitle {
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


- (void)testCapterPredicate2SlashFollowingSiblingStarSlashTitle {
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


- (void)testCapterPredicate3SlashFollowingSiblingStarSlashTitle {
    [self eval:@"chapter[3]/following-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testCapterPredicate3SlashPrecedingSiblingStarSlashTitle {
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


- (void)testCapterPredicate2SlashPrecedingSiblingStarSlashTitle {
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


- (void)testCapterPredicate1SlashPrecedingSiblingStarSlashTitle {
    [self eval:@"chapter[1]/preceding-sibling::*/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreItems]);
}


- (void)testCapterPredicate3SlashPrecedingSiblingStarPredicate1SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[1]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[1], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testCapterPredicate3SlashPrecedingSiblingStarPredicate2SlashTitle {
    [self eval:@"chapter[3]/preceding-sibling::*[2]/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    id <XPNodeInfo>node = nil;
    
    node = [enm nextNodeInfo];
    TDEqualObjects(@"title", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_titles[0], node.stringValue);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testCapterPredicate3SlashPrecedingSiblingChapterPredicate2SlashTitle {
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


- (void)testSlashSlashChapterPredicate1 {
    [self eval:@"//chapter[1]"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameEqChapter {
    [self eval:@"//chapter[1][name()='chapter']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNameDotEqChapter {
    [self eval:@"//chapter[1][name(.)='chapter']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
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
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateLocalNameAtIdEqId {
    [self eval:@"//chapter[1][local-name(@id)='id']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIEqEmptyStr {
    [self eval:@"//chapter[1][namespace-uri()='']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashChapterPredicate1PredicateNamespaceURIAtFooColonBazEqBar {
    [_env declareNamespaceURI:@"bar" forPrefix:@"foobar"];
    [self eval:@"//chapter[1]/@*[namespace-uri(.)='bar']/.."];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_titles[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpace {
    [self eval:@"//chapter[1]/para[normalize-space() = 'Chapter 1 content.']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testNormalizeSpaceSlashSlashChapterSlashParaPredicateNormalizeSpaceDot {
    [self eval:@"//chapter[1]/para[normalize-space(.) = 'Chapter 1 content.']"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDTrue([[node stringValue] hasPrefix:_paras[0]]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testSlashSlashComment {
    [self eval:@"comment()"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeComment, node.nodeType);
    TDEqualObjects(_comments[0], [node stringValue]);
    
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


//- (void)testChapterSlashNamespaceStarChildNode {
//    [self eval:@"chapter/namespace::*/child::node()"];
//    
//    id <XPSequenceEnumeration>enm = [_res enumerate];
//    
//    TDFalse([enm hasMoreItems]);
//}
//
//
//- (void)testChapterSlashNamespaceNodeChildNode {
//    [self eval:@"chapter/namespace::node()/child::node()"];
//    
//    id <XPSequenceEnumeration>enm = [_res enumerate];
//    
//    TDFalse([enm hasMoreItems]);
//}


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

@end
