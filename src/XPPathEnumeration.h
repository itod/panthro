//
//  XPPathEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPAbstractNodeEnumeration.h"

@class XPExpression;
@class XPStep;
@class XPContext;

@interface XPPathEnumeration : XPAbstractNodeEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step context:(XPContext *)ctx;

@end
