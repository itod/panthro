//
//  XPFilterExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPNodeSetExpression.h"

@interface XPFilterExpression : XPNodeSetExpression

- (instancetype)initWithStart:(XPExpression *)start filter:(XPExpression *)filter;

@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPExpression *filter;
@property (nonatomic, assign) XPDependencies dependencies;
@end
