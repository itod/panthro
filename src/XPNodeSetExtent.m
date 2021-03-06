//
//  XPNodeSetExtent.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/25/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetExtent.h"
#import "XPNodeInfo.h"
#import "XPNodeInfo.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"
#import "XPEmptyNodeSet.h"

@interface XPNodeSetExtent ()
@property (nonatomic, retain) NSMutableArray *value;
@property (nonatomic, assign) NSUInteger count;
@end

@implementation XPNodeSetExtent

- (instancetype)initWithNodes:(NSArray *)nodes comparer:(id <XPNodeOrderComparer>)comparer {
    self = [super init];
    if (self) {
        self.value = [[nodes mutableCopy] autorelease];
        self.count = [_value count];
        self.comparer = comparer ? comparer : [XPLocalOrderComparer instance];
        self.sorted = _count < 2;
        self.reverseSorted = _count < 2;
    }
    return self;
}


- (instancetype)initWithEnumeration:(id <XPSequenceEnumeration>)enm comparer:(id <XPNodeOrderComparer>)comparer {
    self = [super init];
    if (self) {
        NSMutableArray *nodes = [NSMutableArray array];
        
        NSUInteger c = 0;
        while ([enm hasMoreItems]) {
            [nodes addObject:[enm nextItem]];
            ++c;
        }
        
        self.value = nodes;
        self.count = c;
        self.comparer = comparer ? comparer : [XPLocalOrderComparer instance];
        self.sorted = enm.isSorted || c < 2;
        self.reverseSorted = enm.isReverseSorted || c < 2;
    }
    return self;
}


- (void)dealloc {
    self.comparer = nil;
    self.value = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPNodeSetExtent *expr = [super copyWithZone:zone];
    expr.value = [[_value copy] autorelease];
    expr.count = _count;
    expr.comparer = _comparer;
    expr.sorted = _sorted;
    expr.reverseSorted = _reverseSorted;
    return expr;
}


#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return [self firstNode];
}


- (id <XPSequenceEnumeration>)enumerate {
    XPAssert(_value);
    id <XPSequenceEnumeration>enm = [[[XPNodeSetValueEnumeration alloc] initWithNodes:_value isSorted:_sorted isReverseSorted:_reverseSorted] autorelease];
    return enm;
}


- (XPExpression *)simplify {
    if (0 == _count) {
        return [XPEmptyNodeSet instance];
    } else if (1 == _count) {
        return [XPSingletonNodeSet singletonNodeSetWithNode:_value[0]];
    } else {
        return self;
    }
}


- (BOOL)asBoolean {
    return _count > 0;
}


- (NSString *)asString {
    return _count ? [[self firstNode] stringValue] : @"";
}


- (BOOL)isSorted {
    return _sorted;
}


- (void)setSorted:(BOOL)sorted {
    _sorted = sorted;
}


- (NSUInteger)count {
    [self sort];
    return _count;
}


- (void)setCount:(NSUInteger)c {
    _count = c;
}


- (XPNodeSetValue *)sort {
    if (_count < 2) self.sorted = YES;
    if (_sorted) return self;
    
    if (_reverseSorted) {
        
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[_value count]];
        for (id obj in [_value reverseObjectEnumerator]) {
            [nodes addObject:obj];
        }
        self.value = nodes;
        self.sorted = YES;
        self.reverseSorted = NO;
        
    } else {
        // sort the array
        
        XPQuickSort(self, 0, _count-1);
        
        // need to eliminate duplicate nodes. Note that we cannot compare the node
        // objects directly, because with attributes and namespaces there might be
        // two objects representing the same node.
        
        NSUInteger j = 1;
        for (NSUInteger i = 1; i < _count; i++) {
            if (![_value[i] isSameNodeInfo:_value[i-1]]) {
                _value[j++] = _value[i];
            }
        }
        
        if (_count - j > 0) {
            [_value removeObjectsInRange:NSMakeRange(j, _count-j)];
        }
        
        self.count = j;
        self.sorted = YES;
        self.reverseSorted = NO;
    }
    
    return self;
}


- (id <XPNodeInfo>)firstNode {
    if (0 == _count) return nil;
    if (_sorted) return _value[0];
    
    // scan to find the first in document order
    id <XPNodeInfo>first = _value[0];
    for (NSUInteger i = 1; i < _count; i++) {
        if ([_comparer compare:_value[i] to:first] < 0) {
            first = _value[i];
        }
    }

    return first;
}


- (id <XPItem>)selectFirstInContext:(XPContext *)ctx {
    return [self firstNode];
}


#pragma mark -
#pragma mark XPSortable

/**
 * Compare two nodes in document sequence
 * (needed to implement the Sortable interface)
 */

- (NSInteger)compare:(NSInteger)a to:(NSInteger)b {
    XPAssert(_comparer);
    return [_comparer compare:_value[a] to:_value[b]];
}

/**
 * Swap two nodes (needed to implement the Sortable interface)
 */

- (void)swap:(NSInteger)a with:(NSInteger)b {
    id <XPItem>temp = _value[a];
    _value[a] = _value[b];
    _value[b] = temp;
}

@synthesize sorted = _sorted;
@synthesize reverseSorted = _reverseSorted;
@synthesize count = _count;
@end
