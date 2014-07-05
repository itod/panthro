//
//  XPAtomicSequenceEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPBaseFastEnumeration.h"

@class XPSequenceExtent;

@interface XPAtomicSequenceEnumeration : XPBaseFastEnumeration

- (instancetype)initWithAtomicSequence:(XPSequenceExtent *)seq;

@end
