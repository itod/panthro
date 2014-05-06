//
//  XPAxisEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <XPath/XPNodeEnumeration.h>

@protocol XPNodeInfo;

@protocol XPAxisEnumeration <XPNodeEnumeration/*, XPLastPositionFinder*/>

/**
 * Get the last position
 */

- (NSUInteger)lastPosition;

@end
