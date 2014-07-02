//
//  XPAxisExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import "XPAxis.h"
#import "XPNodeSetExpression.h"

@class XPNodeTest;
@protocol XPNodeInfo;

@interface XPAxisExpression : XPNodeSetExpression

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *test;
@end
