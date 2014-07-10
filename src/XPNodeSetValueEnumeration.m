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
@property (nonatomic, assign, getter=isReverseSorted) BOOL reverseSorted;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) NSUInteger lastPosition;
@end

@implementation XPNodeSetValueEnumeration

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted isReverseSorted:(BOOL)reverseSorted {
    self = [super init];
    if (self) {
        self.nodes = nodes;
        self.lastPosition = [_nodes count];
        self.index = 0;
        self.sorted = sorted;
        self.reverseSorted = reverseSorted;
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


#pragma mark -
#pragma mark XPPauseHandler

- (NSArray *)currentResultNodes {
    return _nodes;
}


/**
 * Determine whether there are more nodes to come.
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreItems {
    XPAssert(NSNotFound != _index);
    XPAssert(_nodes);
    
    return _index < _lastPosition;
}

/**
 * Get the next node in sequence.
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return the next NodeInfo
 */

- (id <XPItem>)nextItem {
    id <XPItem>node = nil;
    
    if ([self hasMoreItems]) {
        node = _nodes[_index++];
    }
    
    return node;
}


- (BOOL)isPeer {
    return NO;
}

@end
