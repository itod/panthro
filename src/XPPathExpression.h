//
//  XPPathExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNodeSetExpression.h"

@class XPStep;

@interface XPPathExpression : XPNodeSetExpression

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step;

@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPStep *step;
@property (nonatomic, assign) XPDependencies dependencies;
@end
