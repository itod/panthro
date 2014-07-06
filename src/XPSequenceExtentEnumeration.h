//
//  XPSequenceExtentEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPBaseFastEnumeration.h"

@class XPSequenceExtent;

@interface XPSequenceExtentEnumeration : XPBaseFastEnumeration

- (instancetype)initWithSequenceExtent:(XPSequenceExtent *)seq;

@end
