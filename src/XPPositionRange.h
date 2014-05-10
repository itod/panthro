//
//  XPPositionRange.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPExpression.h"

/**
 * PositionRange: a boolean expression that tests whether the position() is
 * within a certain range. This expression can occur in any context but it is
 * optimized when it appears as a predicate (see FilterEnumerator)
 */

@interface XPPositionRange : XPExpression

- (instancetype)initWithMin:(NSUInteger)min max:(NSUInteger)max;

@property (nonatomic, assign) NSUInteger minPosition;
@property (nonatomic, assign) NSUInteger maxPosition;
@end
