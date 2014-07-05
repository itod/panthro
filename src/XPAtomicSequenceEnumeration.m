//
//  XPAtomicSequenceEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPAtomicSequenceEnumeration.h"
#import "XPAtomicSequence.h"

@interface XPAtomicSequenceEnumeration ()
@property (nonatomic, retain) XPAtomicSequence *sequence;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation XPAtomicSequenceEnumeration

- (instancetype)initWithAtomicSequence:(XPAtomicSequence *)seq {
    self = [super init];
    if (self) {
        self.sequence = seq;
    }
    return self;
}


- (void)dealloc {
    self.sequence = nil;
    [super dealloc];
}


- (BOOL)hasMoreItems {
    return _index < [_sequence count];
}


- (id <XPItem>)nextItem {
    id <XPItem>next = [_sequence itemAt:_index];
    self.index++;
    return next;
}


- (id <XPNodeInfo>)nextNode {
    XPAssert(0);
    return nil;
}


/**
 * Determine if we can guarantee that the nodes are in document order. This is true if the
 * start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
 * It is also true if the start is a singleton node and the axis is sorted.
 */

- (BOOL)isSorted {
    return YES;
}


/**
 * Determine if the nodes are guaranteed to be in reverse document order. This is true if the
 * base is singular (e.g. the root node or the current node) and the axis is a reverse axis
 */

- (BOOL)isReverseSorted {
    return NO;
}


/**
 * Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
 * other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
 */

- (BOOL)isPeer {
    return NO;
}

@end
