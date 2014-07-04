//
//  XPNodeEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSequenceEnumeration.h"

@protocol XPNodeInfo;

@protocol XPNodeEnumeration <NSFastEnumeration, XPSequenceEnumeration>

/**
 * Determine whether the nodes returned by this enumeration are known to be in document order
 * @return true if the nodes are guaranteed to be in document order.
 */

- (BOOL)isSorted;

/**
 * Determine whether the nodes returned by this enumeration are known to be in
 * reverse document order.
 * @return true if the nodes are guaranteed to be in document order.
 */

- (BOOL)isReverseSorted;

/**
 * Determine whether there are more nodes to come. <BR>
 * @return true if there are more nodes
 */

- (BOOL)hasMoreObjects;

/**
 * Get the next node in sequence. <BR>
 * @return the next NodeInfo
 */

- (id <XPNodeInfo>)nextObject;

/**
 * Determine whether the nodes returned by this enumeration are known to be peers, that is,
 * no node is a descendant or ancestor of another node. This significance of this property is
 * that if a peer enumeration is applied to each node in a set derived from another peer
 * enumeration, and if both enumerations are sorted, then the result is also sorted.
 */

- (BOOL)isPeer;

@end
