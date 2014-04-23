//
//  XPAxisEnumerator.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPNodeEnumerator.h>

@protocol XPAxisEnumerator <XPNodeEnumerator/*, XPLastPositionFinder*/>

/**
 * Determine whether there are more nodes to come. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreElements;

/**
 * Get the next node in sequence. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return the next NodeInfo
 */

- (id <XPNodeInfo>)nextElement;

/**
 * Get the last position
 */

- (NSUInteger)lastPosition;

@end
