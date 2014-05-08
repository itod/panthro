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

@end
