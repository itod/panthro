//
//  XPPathExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import <XPath/XPath.h>

@class XPStep;

@interface XPPathExpression : XPNodeSetExpression

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step;

@end
