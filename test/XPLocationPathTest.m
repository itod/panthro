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
@property (nonatomic, retain) id res;
@end

@implementation XPLocationPathTest

- (void)setUp {
    [super setUp];

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


//- (void)testImplicitChildAxisNameTestP {
//    self.expr = [XPExpression expressionFromString:@"p" inContext:nil error:nil];
//    TDNotNil(_expr);
//    TDTrue([_expr isKindOfClass:[XPPathExpression class]]);
//    
//    self.res = [_expr evaluateInContext:_ctx];
//    TDNotNil(_res);
//    TDTrue([_res isKindOfClass:[XPNodeSetValue class]]);
//    
//    XPNodeSetValue *nodeSet = (id)_res;
//    id <XPNodeEnumeration>enm = [nodeSet enumerate];
//    
//    id <XPNodeInfo>node = [enm nextObject];
//    TDEqualObjects(@"p", node.name);
//    TDEquals(XPNodeTypeElement, node.nodeType);
//    
//    TDFalse([enm hasMoreObjects]);
//}
@end
