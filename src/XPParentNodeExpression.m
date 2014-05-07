//
//  XPParentNodeExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPParentNodeExpression.h"
#import "XPContext.h"
#import "XPAxis.h"
#import "XPNodeInfo.h"
#import "XPNodeSetValue.h"
#import "XPNodeTypeTest.h"

@implementation XPParentNodeExpression

- (NSString *)description {
    return @"..";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    XPExpression *expr = self;
    
    if (0 != (XPDependenciesContextNode & dep)) {
        XPAssert(0);
        XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
        id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisParent nodeTest:nodeTest];
        
        expr = [[[XPNodeSetValue alloc] initWithEnumeration:enm] autorelease];
    }
    
    return expr;
}
@end
