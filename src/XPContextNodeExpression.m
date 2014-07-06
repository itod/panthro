//
//  XPContextNodeExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPContextNodeExpression.h"
#import "XPContext.h"
#import "XPSequenceValue.h"
#import "XPNodeInfo.h"

@implementation XPContextNodeExpression

- (NSString *)description {
    return @"context-node()";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


- (id <XPNodeInfo>)nodeInContext:(XPContext *)ctx {
    return ctx.contextNode;
}

@end
