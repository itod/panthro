//
//  XPNodeSetValueEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPAxisEnumeration.h"

@interface XPNodeSetValueEnumeration : NSObject <XPAxisEnumeration>

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted;

@end
