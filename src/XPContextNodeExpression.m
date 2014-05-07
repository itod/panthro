//
//  XPContextNodeExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPContextNodeExpression.h"
#import "XPContext.h"
#import "XPNodeSetValue.h"

@implementation XPContextNodeExpression

- (NSString *)description {
    return @"context-node()";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    XPExpression *expr = self;
    
    if (0 != (XPDependenciesContextNode & dep)) {
        expr = [[[XPNodeSetValue alloc] initWithNodes:@[ctx.contextNode]] autorelease];
    }
    
    return expr;
}

@end
