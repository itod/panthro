//
//  XPStep.h
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

#if PAUSE_ENABLED
@class XPPauseState;
#endif

@interface XPStep : NSObject

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest;

- (XPStep *)addFilter:(XPExpression *)expr;
- (XPStep *)simplify;
- (id <XPSequenceEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx parent:(XPExpression *)expr;

@property (nonatomic, retain, readonly) NSArray *filters;
@property (nonatomic, assign, readonly) NSUInteger numberOfFilters;
@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *nodeTest;

@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSRange subRange;
@property (nonatomic, retain) NSArray *filterRanges;

#if PAUSE_ENABLED
@property (nonatomic, retain) XPPauseState *pauseState;
@property (nonatomic, retain) NSMutableArray *filterPauseStates;
#endif
@end
