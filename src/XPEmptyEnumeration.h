//
//  XPEmptyEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPAbstractNodeEnumeration.h"
#import "XPAxisEnumeration.h"

@interface XPEmptyEnumeration : XPAbstractNodeEnumeration <XPAxisEnumeration>

+ (instancetype)instance;

@end
