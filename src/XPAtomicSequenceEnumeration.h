//
//  XPAtomicSequenceEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPBaseFastEnumeration.h"

@protocol XPAtomicSequence;

@interface XPAtomicSequenceEnumeration : XPBaseFastEnumeration

- (instancetype)initWithAtomicSequence:(id <XPAtomicSequence>)seq;

@end
