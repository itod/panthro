//
//  XPAxisStepTest.m
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

@interface XPAxisStepTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) id <XPStaticContext>env;
@property (nonatomic, retain) XPContext *ctx;
@property (nonatomic, retain) XPSequenceValue *res;
@end

@implementation XPAxisStepTest

- (void)setUp {
    [super setUp];

    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithXMLString:@"<doc><p><a/></p><!-- foo --></doc>" options:0 error:nil] autorelease];
    TDNotNil(doc);
    id <XPNodeInfo>docNode = [XPNSXMLNodeImpl nodeInfoWithNode:doc];
    TDNotNil(docNode);
    
    NSXMLNode *docEl = [doc rootElement];
    id <XPNodeInfo>docElNode = [XPNSXMLNodeImpl nodeInfoWithNode:docEl];
    
    self.env = [[[XPStandaloneContext alloc] init] autorelease];
    self.ctx = [[[XPContext alloc] initWithStaticContext:_env] autorelease];
    _ctx.contextNode = docElNode;
}


- (void)tearDown {

    [super tearDown];
}


- (void)testImplicitChildAxisNameTestP {
    self.expr = [XPExpression expressionFromString:@"p" inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"p", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestPSlashA {
    self.expr = [XPExpression expressionFromString:@"p/a" inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestPSlashA {
    self.expr = [XPExpression expressionFromString:@"child::p/child::a" inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testExplicitChildAxisNameTestDotSlashPSlashA {
    self.expr = [XPExpression expressionFromString:@"./child::p/child::a" inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"a", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testImplicitChildAxisNameTestStar {
    self.expr = [XPExpression expressionFromString:@"*" inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"p", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDot {
    self.expr = [XPExpression expressionFromString:@"." inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    TDTrue([_res isKindOfClass:[XPSequenceValue class]]);
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"doc", node.name);
    TDEquals(XPNodeTypeElement, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotDot {
    self.expr = [XPExpression expressionFromString:@".." inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotSlashDotDot {
    self.expr = [XPExpression expressionFromString:@"./.." inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testDotDotSlashDot {
    self.expr = [XPExpression expressionFromString:@"../." inContext:_env error:nil];
    TDNotNil(_expr);
    
    self.res = (id)[_expr evaluateInContext:_ctx];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    id <XPNodeInfo>node = [enm nextNodeInfo];
    TDEqualObjects(@"", node.name);
    TDEquals(XPNodeTypeRoot, node.nodeType);
    
    TDFalse([enm hasMoreItems]);
}

@end
