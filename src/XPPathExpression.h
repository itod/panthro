//
//  XPPathExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPNodeSetExpression.h"

@interface XPPathExpression : XPNodeSetExpression

- (instancetype)initWithStart:(XPExpression *)start step:(XPExpression *)step;

@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPExpression *step;
@property (nonatomic, assign) XPDependencies dependencies;
@end
