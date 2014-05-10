//
//  XPNodeSetValueEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPBaseFastEnumeration.h"
#import "XPAxisEnumeration.h"

@interface XPNodeSetValueEnumeration : XPBaseFastEnumeration <XPAxisEnumeration>

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted;

@end
