//
//  XPAtomicSequenceEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPBaseFastEnumeration.h"

@class XPAtomicSequence;

@interface XPAtomicSequenceEnumeration : XPBaseFastEnumeration

- (instancetype)initWithAtomicSequence:(XPAtomicSequence *)seq;

@end
