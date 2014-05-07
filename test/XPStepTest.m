//
//  XPStepTest.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"
#import "XPNodeTypeTest.h"
#import "XPNSXMLNodeImpl.h"
#import "XPPathExpression.h"

@interface XPStepTest : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) id res;
@end

@implementation XPStepTest

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)testDot {
    NSXMLNode *node = [[[NSXMLDocument alloc] initWithXMLString:@"<doc><p/></doc>" options:0 error:nil] autorelease];
    TDNotNil(node);
    id <XPNodeInfo>nodeInfo = [[[XPNSXMLNodeImpl alloc] initWithNode:node] autorelease];
    TDNotNil(nodeInfo);
    
    XPContext *ctx = [[[XPContext alloc] initWithStaticContext:nil] autorelease];
    ctx.contextNode = nodeInfo;
    
    self.expr = [XPExpression expressionFromString:@"." inContext:nil error:nil];
    TDNotNil(_expr);
    TDTrue([_expr isKindOfClass:[XPPathExpression class]]);
    
    self.res = [_expr evaluateInContext:nil];
    TDNotNil(_res);
    
}

- (void)testExample {
    NSXMLNode *node = [[[NSXMLDocument alloc] initWithXMLString:@"<doc><p/></doc>" options:0 error:nil] autorelease];
    TDNotNil(node);
    id <XPNodeInfo>nodeInfo = [[[XPNSXMLNodeImpl alloc] initWithNode:node] autorelease];
    TDNotNil(nodeInfo);
    
    XPContext *ctx = [[[XPContext alloc] initWithStaticContext:nil] autorelease];
    ctx.contextNode = nodeInfo;
    
    self.expr = [XPExpression expressionFromString:@"node()" inContext:nil error:nil];
    TDNotNil(_expr);
    TDTrue([_expr isKindOfClass:[XPPathExpression class]]);
    
    self.res = [_expr evaluateInContext:nil];
    TDNotNil(_res);
    
}

@end
