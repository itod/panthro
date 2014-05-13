//
//  XPLastPositionFinder.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import <Foundation/Foundation.h>

/**
 * A LastPositionFinder is an object used by the Context to locate the last position in the
 * context node list.
 */

@protocol XPLastPositionFinder <NSObject>


/**
 * Get the last position
 */

- (NSUInteger)lastPosition;

@end
