//
//  XPPathEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPBaseFastEnumeration.h"

@class XPExpression;
@class XPStep;
@class XPContext;
@protocol XPNodeInfo;

@interface XPPathEnumeration : XPBaseFastEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step context:(XPContext *)ctx;

@end
