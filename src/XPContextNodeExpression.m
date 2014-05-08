//
//  XPContextNodeExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPContextNodeExpression.h"
#import "XPContext.h"
#import "XPAxis.h"
#import "XPNodeTypeTest.h"
#import "XPNodeInfo.h"
#import "XPNodeSetValue.h"

@implementation XPContextNodeExpression

- (NSString *)description {
    return @"context-node()";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    return self;
//    XPAssert(ctx);
//    
//    XPExpression *expr = self;
//    
//    if (0 != (XPDependenciesContextNode & dep)) {
//        //expr = [[[XPNodeSetValue alloc] initWithNodes:@[ctx.contextNode]] autorelease];
//        
//        XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
//        id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisSelf nodeTest:nodeTest];
//        XPAssert(enm);
//        
//        expr = [[[XPNodeSetValue alloc] initWithEnumeration:enm] autorelease];
//    }
//    
//    return expr;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisSelf nodeTest:nodeTest];
    XPAssert(enm);
    return enm;
}

@end
