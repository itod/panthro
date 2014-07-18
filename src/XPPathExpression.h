//
//  XPPathExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNodeSetExpression.h"

@class XPAxisStep;

@interface XPPathExpression : XPNodeSetExpression

- (instancetype)initWithStart:(XPExpression *)start step:(XPAxisStep *)step;

@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPAxisStep *step;
@property (nonatomic, assign) XPDependencies dependencies;
@end
