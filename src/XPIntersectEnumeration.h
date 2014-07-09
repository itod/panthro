//
//  XPIntersectEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPUnionEnumeration.h"

@protocol XPNodeOrderComparer;

@interface XPIntersectEnumeration : XPUnionEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer;
@end
