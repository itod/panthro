//
//  XPPathEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 6/30/14.
//
//

#import "XPAbstractNodeEnumeration.h"

@class XPExpression;
@class XPAxisStep;
@class XPContext;

@interface XPPathEnumeration : XPAbstractNodeEnumeration

- (instancetype)initWithStart:(XPExpression *)start step:(XPAxisStep *)step context:(XPContext *)ctx;

@end
