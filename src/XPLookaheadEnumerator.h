//
//  XPLookaheadNumerator.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPBaseFastEnumeration.h"
#import "XPLastPositionFinder.h"

// The way this class works is that all calls to hasMoreElements() and nextElement() are
// simply delegated to the underlying enumeration, until such time as the client calls
// getLastPosition() to find out how many nodes there are. At this point the remaining nodes
// are read from the underlying enumeration into a reservoir to find out how many there are;
// and from this point on, requests for more nodes are met from the reservoir rather than
// from the underlying enumeration. The reason for all this is to avoid allocating temporary
// storage for the nodes unless the user actually calls last() to find out how many there are.

@interface XPLookaheadEnumerator : XPBaseFastEnumeration <XPLastPositionFinder>

- (instancetype)initWithBase:(id <XPNodeEnumeration>)base;
@end
