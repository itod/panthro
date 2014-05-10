//
//  XPEmptyEnumeration.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPBaseFastEnumeration.h"
#import "XPAxisEnumeration.h"

@interface XPEmptyEnumeration : XPBaseFastEnumeration <XPAxisEnumeration>

+ (instancetype)instance;

@end
