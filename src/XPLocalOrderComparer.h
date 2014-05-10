//
//  XPLocalOrderComparer.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/5/14.
//
//

#import "XPNodeOrderComparer.h"

/**
 * A Comparer used for comparing nodes in document order. This
 * comparer assumes that the nodes being compared come from the same document
 *
 */

@interface XPLocalOrderComparer : NSObject <XPNodeOrderComparer>
+ (instancetype)instance;
@end
