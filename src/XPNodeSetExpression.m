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
#import "XPNodeSetValue.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"

#import "XPStaticContext.h"
#import "XPException.h"
#import "XPSync.h"
#import "XPContext.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeSetValue.h"
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

        if (ctx.staticContext.debug) {
            id info = @{@"contextNode": ctx.contextNode, @"result": result, @"done": @NO, @"mainQueryRange": [NSValue valueWithRange:result.range]};
            [ctx.staticContext.debugSync pause:info];
            BOOL resume = [[ctx.staticContext.debugSync awaitResume] boolValue];
            
            if (!resume) {
                [XPException raiseIn:self format:@"User Terminated"];
            }
        }
        
    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        id <XPNodeEnumeration>enm = [(XPNodeSetExpression *)expr enumerateInContext:ctx sorted:NO];
        XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithEnumeration:enm comparer:[XPLocalOrderComparer instance]] autorelease];
        nodeSet.range = self.range;
        result = nodeSet; // TODO [XPNodeSetIntent intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:[ctx controller]];
    } else {
        result = [expr evaluateInContext:ctx];
        if (![result isKindOfClass:[XPNodeSetValue class]]) {
            [XPException raiseIn:self format:@"Value must be a node-set. it is a %@", [expr class]];
        }
    }

    result.range = self.range;
    return result;
}

@end
