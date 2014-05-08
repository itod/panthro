//
//  XPNodeEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPNodeInfo;

@protocol XPNodeEnumeration <NSFastEnumeration, NSObject>

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
@end
