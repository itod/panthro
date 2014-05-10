//
//  XPAxisExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 1/13/14.
//
//

#import <XPath/XPAxis.h>
#import "XPNodeSetExpression.h"

@class XPNodeTest;
@protocol XPNodeInfo;

@interface XPAxisExpression : XPNodeSetExpression

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *test;
@property (nonatomic, retain) id <XPNodeInfo>contextNode;
@end
