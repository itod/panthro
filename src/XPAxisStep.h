//
//  XPAxisStep.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPExpression.h"
#import "XPAxis.h"

@class XPExpression;
@class XPNodeTest;
@class XPContext;

@protocol XPSequenceEnumeration;
@protocol XPNodeInfo;

@interface XPAxisStep : XPExpression

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

- (id <XPSequenceEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx parent:(XPExpression *)expr;

@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *nodeTest;

@property (nonatomic, assign) NSRange baseRange;
@end
