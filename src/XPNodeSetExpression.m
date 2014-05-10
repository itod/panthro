//
//  XPNodeSetExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPNodeSetExpression.h>
#import <XPath/XPContext.h>
#import <XPath/XPNodeEnumeration.h>
#import <XPath/XPNodeSetValue.h>
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
    XPExpression *expr = [self reduceDependencies:XPDependenciesAll inContext:ctx];
    
    if ([expr isKindOfClass:[XPNodeSetValue class]]) {
        return (XPValue *)expr;
    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        id <XPNodeEnumeration>enm = [(XPNodeSetExpression *)expr enumerateInContext:ctx sorted:NO];
        XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithEnumeration:enm comparer:[XPLocalOrderComparer instance]] autorelease];
        return nodeSet; // TODO [XPNodeSetIntent intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:[ctx controller]];
    } else {
        XPValue *value = [expr evaluateInContext:ctx];
        if ([value isKindOfClass:[XPNodeSetValue class]]) {
            return value;
        } else {
            [NSException raise:@"XPathException" format:@"Value must be a node-set. it is a %@", [expr class]];
            return nil;
        }
    }
}

@end
