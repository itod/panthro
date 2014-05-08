//
//  XPEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import <XPath/XPNodeEnumeration.h>

@interface XPEnumeration : NSObject <XPNodeEnumeration>

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted;

@end
