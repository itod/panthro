//
//  XPEnumeration.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPEnumeration.h"

@interface XPEnumeration ()
@property (nonatomic, copy) NSArray *nodes;
@property (nonatomic, assign) BOOL isSorted;
@property (nonatomic, assign) NSUInteger idx;
@property (nonatomic, assign) NSUInteger lastPosition;
@end

@implementation XPEnumeration

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted {
    self = [super init];
    if (self) {
        self.nodes = nodes;
        self.lastPosition = [_nodes count];
        self.idx = 0;
    }
    return self;
}


- (void)dealloc {
    self.nodes = nil;
    [super dealloc];
}


- (BOOL)isReverseSorted {
    return !_isSorted;
}

/**
 * Determine whether there are more nodes to come. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreObjects {
    XPAssert(NSNotFound != _idx);
    XPAssert(_nodes);
    
    return _idx < _lastPosition;
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
        node = _nodes[_idx++];
    }
    
    return node;
}


- (NSArray *)allObjects {
    XPAssert(_nodes);
    return [[_nodes copy] autorelease];
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    NSUInteger count = 0;
    
    id <XPNodeInfo>node = nil;
    
    if (0 == state->state) {
        node = [self nextObject];
    } else {
        node = (id <XPNodeInfo>)state->state;
    }
    
    while ([self hasMoreObjects] && count < len) {
        stackbuf[count] = node;
        node = [self nextObject];
        count++;
    }
    
    state->state = (unsigned long)node;
    state->itemsPtr = stackbuf;
    state->mutationsPtr = (unsigned long *)self;
    
    return count;
}

@end
