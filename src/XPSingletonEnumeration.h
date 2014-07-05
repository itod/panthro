//
//  XPSingletonEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPBaseFastEnumeration.h"
#import "XPAxisEnumeration.h"

@interface XPSingletonEnumeration : XPBaseFastEnumeration <XPAxisEnumeration>
- (instancetype)initWithItem:(id <XPItem>)node;
@end
