//
//  XPUnionEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPBaseFastEnumeration.h"

@protocol XPNodeOrderComparer;

@interface XPUnionEnumeration : XPBaseFastEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer;
@end
