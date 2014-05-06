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
- (BOOL)isSorted;
- (BOOL)isReverseSorted;
- (BOOL)isPeer;

/**
 * Determine whether there are more nodes to come. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreObjects;

/**
 * Get the next node in sequence. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return the next NodeInfo
 */

- (id <XPNodeInfo>)nextObject;
@end
