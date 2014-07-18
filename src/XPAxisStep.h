//
//  XPAxisStep.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import <Foundation/Foundation.h>
#import "XPAxis.h"

@class XPExpression;
@class XPNodeTest;
@class XPContext;

@protocol XPSequenceEnumeration;
@protocol XPNodeInfo;

@interface XPAxisStep : NSObject <NSCopying>

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

- (XPAxisStep *)addFilter:(XPExpression *)expr;
- (XPAxisStep *)simplify;
- (id <XPSequenceEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx parent:(XPExpression *)expr;

@property (nonatomic, retain, readonly) NSArray *filters;
@property (nonatomic, assign, readonly) NSUInteger numberOfFilters;
@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *nodeTest;

@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSRange baseRange;
@end
