//
//  XPComparer.m
//  XPath
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPComparer.h>
#import <XPath/XPDescendingComparer.h>

@implementation XPComparer

- (NSComparisonResult)compare:(id)a to:(id)b {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NSOrderedSame;
}


- (XPComparer *)comparerForDataTypeURI:(NSString *)dataTypeURI localName:(NSString *)dataTypeLocalName {
    return self;
}


- (XPComparer *)ascendingComparer:(BOOL)ascending {
    return ascending ? self : [XPDescendingComparer descendingComparerWithComparer:self];
}

@end
