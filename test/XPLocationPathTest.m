//
//  XPLocationPathTest.m
//  XPath
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

@interface XPLocationPathTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) XPContext *ctx;
@property (nonatomic, retain) XPNodeSetValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@end

@implementation XPLocationPathTest

- (void)setUp {
    [super setUp];

    self.ids = @[@"c1", @"c2", @"c3"];
    self.titles = @[@"Chapter 1", @"Chapter 2", @"Chapter 3"];
    self.paras = @[@"Chapter 1 content.", @"Chapter 2 content.", @"Chapter 3 content."];

    NSString *str = XPContentsOfFile(@"book.xml");
    NSError *err = nil;
    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:str options:0 error:&err] autorelease];
    TDNotNil(doc);
    TDNil(err);
    
    id <XPNodeInfo>docNode = [[[XPNSXMLDocumentImpl alloc] initWithNode:doc sortIndex:0] autorelease];
    TDNotNil(docNode);
    
    //
    // NOTE: the <book> outermost element is the context node in all tests!!!
    //
    
    NSXMLNode *docEl = [doc rootElement];
    id <XPNodeInfo>docElNode = [[[XPNSXMLNodeImpl alloc] initWithNode:docEl sortIndex:1] autorelease];
    
    id <XPStaticContext>env = [[[XPStandaloneContext alloc] init] autorelease];
    self.ctx = [[[XPContext alloc] initWithStaticContext:env] autorelease];
    _ctx.contextNode = docElNode;
}


- (void)tearDown {

    [super tearDown];
}


- (void)testImplicitChildAxisNameTestChapter {
    self.expr = [XPExpression expressionFromString:@"chapter" inContext:nil error:nil];
   
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];

    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapter {
    self.expr = [XPExpression expressionFromString:@"child::chapter" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"chapter", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterSlashTitle {
    self.expr = [XPExpression expressionFromString:@"chapter/title" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"child::chapter/child::title" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"chapter[1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate2 {
    self.expr = [XPExpression expressionFromString:@"chapter[2]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicate3 {
    self.expr = [XPExpression expressionFromString:@"chapter[3]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq1 {
    self.expr = [XPExpression expressionFromString:@"chapter[position()=1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq2 {
    self.expr = [XPExpression expressionFromString:@"chapter[position()=2]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionEq3 {
    self.expr = [XPExpression expressionFromString:@"chapter[position()=3]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateLast {
    self.expr = [XPExpression expressionFromString:@"chapter[last()]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicatePositionNeLast {
    self.expr = [XPExpression expressionFromString:@"chapter[position()!=last()]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"chapter[position()!=3]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"chapter[position()!=0]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"chapter[attribute::id='c1']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC2 {
    self.expr = [XPExpression expressionFromString:@"chapter[attribute::id='c2']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAttributeIdEqC3 {
    self.expr = [XPExpression expressionFromString:@"chapter[attribute::id='c3']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c1']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c2']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c3']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC1 {
    self.expr = [XPExpression expressionFromString:@"child::chapter[@id='c1']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC2 {
    self.expr = [XPExpression expressionFromString:@"child::chapter[@id='c2']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[1], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestChapterPredicateAtIdEqC3 {
    self.expr = [XPExpression expressionFromString:@"child::chapter[@id='c3']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[2], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testChapterPredicateAtIdEqC3SlashPara {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c3']/para" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1OrIdEqC3 {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c1' or @id='c3']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c1' and self::node()]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfStar {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c1' and self::*]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);

    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestChapterPredicateAtIdEqC1AndSelfAttribute {
    self.expr = [XPExpression expressionFromString:@"chapter[@id='c1' and self::text()]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashCapterPredicateAtIdEqC1 {
    self.expr = [XPExpression expressionFromString:@"//chapter[@id='c1']" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"chapter", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_ids[0], [node attributeValueForURI:nil localName:@"id"]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashPara {
    self.expr = [XPExpression expressionFromString:@"//para" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotSlashSlashPara {
    self.expr = [XPExpression expressionFromString:@".//para" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
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
    self.expr = [XPExpression expressionFromString:@"/descendant::para[1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicate1 {
    self.expr = [XPExpression expressionFromString:@"(//para)[1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[0], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2 {
    self.expr = [XPExpression expressionFromString:@"(//para)[position()=1 or position()=3][2]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testOpenSlashSlashParaClosePredicatePos1OrPos3Predicate2Predicate1 {
    self.expr = [XPExpression expressionFromString:@"(//para)[position()=1 or position()=3][2][1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"para", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    TDEqualObjects(_paras[2], [node stringValue]);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testSlashSlashParaPredicate1 {
    self.expr = [XPExpression expressionFromString:@"//para[1]" inContext:nil error:nil];
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    id <XPNodeEnumeration>enm = [_res enumerate];

    for (NSUInteger i = 0; i < 3; ++i) {
        id <XPNodeInfo>node = [enm nextObject];
        TDEqualObjects(@"para", node.name);
        TDEquals(XPNodeTypeElement, node.nodeType);
        TDEqualObjects(_paras[i], node.stringValue);
    }
    
    TDFalse([enm hasMoreObjects]);
}

@end
