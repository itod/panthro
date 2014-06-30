//
//  XPNodeSetValueEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPNodeSetValueEnumeration.h"

@interface XPNodeSetValueEnumeration ()
@property (nonatomic, assign, getter=isSorted) BOOL sorted;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) NSUInteger lastPosition;
@end

@implementation XPNodeSetValueEnumeration

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted {
    self = [super init];
    if (self) {
        self.nodes = nodes;
        self.lastPosition = [_nodes count];
        self.index = 0;
        self.sorted = sorted;
    }
    return self;
}


- (void)dealloc {
    self.nodes = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %lu>", [self class], self, [self.nodes count]];
}


- (BOOL)isReverseSorted {
    return !_sorted;
}

/**
 * Determine whether there are more nodes to come. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreObjects {
    XPAssert(NSNotFound != _index);
    XPAssert(_nodes);
    
    return _index < _lastPosition;
}

/**
 * Get the next node in sequence. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return the next NodeInfo
 */

- (id <XPNodeInfo>)nextObject {
    id <XPNodeInfo>node = nil;
    
    if ([self hasMoreObjects]) {
        node = _nodes[_index++];
    }
    
    return node;
}


- (BOOL)isPeer {
    return NO;
}


- (NSUInteger)lastPosition {
    XPAssert(_nodes);
    return [_nodes count];
}

@end
