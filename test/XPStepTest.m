//
//  XPStepTest.m
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

@interface XPStepTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) id <XPStaticContext>env;
@property (nonatomic, retain) XPContext *ctx;
@property (nonatomic, retain) id res;
@end

@implementation XPStepTest

- (void)setUp {
    [super setUp];

    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:@"<doc><p><a/></p><!-- foo --></doc>" options:0 error:nil] autorelease];
    TDNotNil(doc);
    id <XPNodeInfo>docNode = [[[XPNSXMLDocumentImpl alloc] initWithNode:doc sortIndex:0] autorelease];
    TDNotNil(docNode);
    
    NSXMLNode *docEl = [doc rootElement];
    id <XPNodeInfo>docElNode = [[[XPNSXMLNodeImpl alloc] initWithNode:docEl sortIndex:1] autorelease];
    
    self.env = [[[XPStandaloneContext alloc] init] autorelease];
    self.ctx = [[[XPContext alloc] initWithStaticContext:_env] autorelease];
    _ctx.contextNode = docElNode;
}


- (void)tearDown {

    [super tearDown];
}


- (void)testImplicitChildAxisNameTestP {
    self.expr = [XPExpression expressionFromString:@"p" inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"p", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestPSlashA {
    self.expr = [XPExpression expressionFromString:@"p/a" inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestPSlashA {
    self.expr = [XPExpression expressionFromString:@"child::p/child::a" inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testExplicitChildAxisNameTestDotSlashPSlashA {
    self.expr = [XPExpression expressionFromString:@"./child::p/child::a" inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testImplicitChildAxisNameTestStar {
    self.expr = [XPExpression expressionFromString:@"*" inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"p", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDot {
    self.expr = [XPExpression expressionFromString:@"." inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(@"doc", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotDot {
    self.expr = [XPExpression expressionFromString:@".." inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(nil, node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotSlashDotDot {
    self.expr = [XPExpression expressionFromString:@"./.." inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(nil, node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}


- (void)testDotDotSlashDot {
    self.expr = [XPExpression expressionFromString:@"../." inContext:_env error:nil];
    
    self.res = [_expr evaluateInContext:_ctx];
    TDNotNil(_res);
    
    XPNodeSetValue *nodeSet = (id)_res;
    id <XPNodeEnumeration>enm = [nodeSet enumerate];
    
    id <XPNodeInfo>node = [enm nextObject];
    TDEqualObjects(nil, node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreObjects]);
}

@end
