//
//  XPNodeSetExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPNodeSetExtent.h"
//#import "XPNodeSetIntent.h"
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
    return XPDataTypeSequence;
}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *result = nil;
    XPExpression *expr = [self reduceDependencies:XPDependenciesAll inContext:ctx];
    
    if ([expr isKindOfClass:[XPSequenceValue class]]) {
        result = (XPValue *)expr;

    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        
        id <XPSequenceEnumeration>enm = [(XPNodeSetExpression *)expr enumerateInContext:ctx sorted:YES];
        
        if (enm) {
            XPNodeSetValue *nodeSet = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:nil] autorelease];
            nodeSet.range = self.range;
            result = nodeSet;
        } else {
            result = [XPEmptyNodeSet instance];
        }

//        XPNodeSetIntent *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPNodeSetExpression *)expr comparer:nil] autorelease];
//        result = nsi;

    } else {
        result = [expr evaluateInContext:ctx];
        if (![result isKindOfClass:[XPSequenceValue class]]) {
            [XPException raiseIn:self format:@"Value must be a node-set. it is a %@", [expr class]];
        }
    }
    
    result.staticContext = self.staticContext;
    result.range = self.range;
    return result;
}

@end
