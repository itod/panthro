//
//  XPNodeSetExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExpression.h"
#import "XPContext.h"
#import "XPNodeEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPNodeSetIntent.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"
#import "XPEmptyNodeSet.h"

#import "XPStaticContext.h"
#import "XPException.h"
#import "XPSync.h"
#import "XPContext.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPLocalOrderComparer.h"

@implementation XPNodeSetExpression

- (XPDataType)dataType {
    return XPDataTypeNodeSet;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *result = nil;
    XPExpression *expr = [self reduceDependencies:XPDependenciesAll inContext:ctx];
    
    if ([expr isKindOfClass:[XPNodeSetValue class]]) {
        result = (XPValue *)expr;

#if PAUSE_ENABLED
        [ctx.staticContext pauseFrom:self withContextNode:ctx.contextNode result:result range:result.range done:NO];
#endif
        
    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        
        XPNodeSetValue *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPNodeSetExpression *)expr comparer:nil] autorelease];
        result = nsi;

    } else {
        result = [expr evaluateInContext:ctx];
        if (![result isKindOfClass:[XPNodeSetValue class]]) {
            [XPException raiseIn:self format:@"Value must be a node-set. it is a %@", [expr class]];
        }
    }
    
    result.staticContext = self.staticContext;
    result.range = self.range;
    return result;
}

@end
