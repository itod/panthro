//
//  XPNodeSetExpression.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPNodeSetExpression.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPNodeEnumerator.h>
#import <Exedore/XPNodeSetValue.h>
#import <Exedore/XPNodeSetIntent.h>

@implementation XPNodeSetExpression

- (XPNodeEnumerator *)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPExpression *expr = [self reduceDependencies:XPDependenciesAll inContext:ctx];
    
    if ([expr isKindOfClass:[XPNodeSetValue class]]) {
        return (XPValue *)expr;
    } else if ([expr isKindOfClass:[XPNodeSetExpression class]]) {
        return [XPNodeSetIntent intentWithNodeSetExpression:(XPNodeSetExpression *)expr controller:[ctx controller]];
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
