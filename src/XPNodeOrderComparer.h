//
//  XPNodeOrderComparer.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/5/14.
//
//

#import <Foundation/Foundation.h>

@protocol XPNodeInfo <NSObject>
@end

/**
 * A Comparer used for comparing nodes in document order
 *
 */

@protocol XPNodeOrderComparer <NSObject>

/**
 * Compare two objects.
 * @return <0 if a<b, 0 if a=b, >0 if a>b
 */

- (NSInteger)compare:(id <XPNodeInfo>)a to:(id <XPNodeInfo>)b;
@end
