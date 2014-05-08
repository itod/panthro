//
//  XPAxisExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import <XPath/XPAxisExpression.h>
#import <XPath/XPNodeInfo.h>
#import <XPath/XPNodeTest.h>

@interface XPAxisExpression ()
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


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (!_contextNode && (dep & XPDependenciesContextNode) != 0) {
        XPAxisExpression *exp2 = [[[XPAxisExpression alloc] initWithAxis:_axis nodeTest:_test] autorelease];
        exp2.contextNode = ctx.contextNode;
        return exp2;
    } else {
        return self;
    }
}


//- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
//    id <XPNodeInfo>start = nil;
//    if (!_contextNode) {
//        start = ctx.contextNode;
//    } else {
//        start = _contextNode;
//    }
//
//    XPAxisEnumeration enm = [start enumerationWithAxis:_axis nodeTest:_test];
//    if (sorted && ![enm isSorted]) {
//        XPNodeSetExtent *ns = [[[XPNodeSetExtent alloc] initWithNodeEnumeration:enm controller:[XPLocalOrderComparer instance]]];
//        [ns sort];
//        return [ns enumerate];
//    }
//    return enm;
//}
//
//
//- (XPValue *)evaluateInContext:(XPContext *)ctx {
//    XPNodeSetExpression *nse = (id)[self reduceDependencies:XPDependenciesContextNode inContext:ctx];
//    XPNodeSetIntent *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:nse controller:[ctx controller]] autorelease];
//    [nsi setSorted:[XPAxis isForwards:axis]];
//    return nsi;
//}

@end
