//
//  XPPathEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPBaseFastEnumeration.h"

@class XPExpression;
@class XPContext;

@interface XPPathEnumeration : XPBaseFastEnumeration

- (instancetype)initWithStart:(XPExpression *)start context:(XPContext *)ctx;

@end
