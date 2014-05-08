//
//  XPAxisEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPNodeEnumeration.h>
#import "XPLastPositionFinder.h"

@protocol XPNodeInfo;

/**
 * A NodeEnumeration is used to iterate over a list of nodes. An AxisEnumeration
 * is a NodeEnumeration that throws no exceptions; it also supports the ability
 * to find the last() position, again with no exceptions.
 */
@protocol XPAxisEnumeration <XPNodeEnumeration, XPLastPositionFinder>

/**
 * Get the last position
 */

- (NSUInteger)lastPosition;
@end
