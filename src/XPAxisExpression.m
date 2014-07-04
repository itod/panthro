//
//  XPAxisExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPAxisExpression.h"
#import "XPAxisEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPNodeSetIntent.h"
#import "XPNodeInfo.h"
#import "XPNodeTest.h"

@interface XPAxisExpression ()
@property (nonatomic, retain) id <XPItem>contextNode;
@end

@implementation XPAxisExpression

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    self = [super init];
    if (self) {
        self.axis = axis;
        self.test = nodeTest;
    }
    return self;
}


- (void)dealloc {
    self.test = nil;
    self.contextNode = nil;
    [super dealloc];
}


- (XPExpression *)simplify {
    return self;
}


- (XPDependencies)dependencies {
    if (!_contextNode) {
        return XPDependenciesContextNode;
    } else {
        return 0;
    }
}


- (BOOL)isContextDocumentNodeSet {
    return YES;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;
    
    if (!_contextNode && (dep & XPDependenciesContextNode) != 0) {
        XPAxisExpression *expr = [[[XPAxisExpression alloc] initWithAxis:_axis nodeTest:_test] autorelease];
        expr.contextNode = ctx.contextNode;
        expr.staticContext = self.staticContext;
        expr.range = self.range;
        result = expr;
    }
    
    return result;
}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    id <XPItem>start = nil;
    if (!_contextNode) {
        start = ctx.contextNode;
    } else {
        start = _contextNode;
    }

    id <XPAxisEnumeration>enm = [start enumerationForAxis:_axis nodeTest:_test];
    if (sorted && ![enm isSorted]) {
        XPNodeSetExtent *ns = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:nil] autorelease];
        [ns sort];
        return [ns enumerate];
    }
    return enm;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPNodeSetExpression *nse = (id)[self reduceDependencies:XPDependenciesContextNode inContext:ctx];
    XPNodeSetIntent *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:nse comparer:nil] autorelease];
    nsi.sorted = XPAxisIsForwards[_axis];
    nsi.staticContext = self.staticContext;
    nsi.range = self.range;
    return nsi;
}

@end
