//
//  XPStep.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPStep.h"
#import "XPNodeTest.h"
#import "XPExpression.h"
#import "XPValue.h"
#import "XPNodeInfo.h"
#import "XPAxisEnumeration.h"
#import "XPFilterEnumerator.h"

#import "XPStaticContext.h"
#import "XPException.h"
#import "XPSync.h"
#import "XPContext.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeSetExtent.h"
#import "XPLocalOrderComparer.h"

#if PAUSE_ENABLED
#import "XPStaticContext.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPSingletonEnumeration.h"
#import "XPPauseState.h"
#endif

@interface XPStep ()
@property (nonatomic, retain) NSMutableArray *allFilters;
#if PAUSE_ENABLED
@property (nonatomic, retain) XPPauseState *pauseState;
#endif
@end

@implementation XPStep

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    self = [super init];
    if (self) {
        self.axis = axis;
        self.nodeTest = nodeTest;
        
#if PAUSE_ENABLED
        self.pauseState = [[[XPPauseState alloc] init] autorelease];
#endif

    }
    return self;
}


- (void)dealloc {
    self.nodeTest = nil;
    self.allFilters = nil;

#if PAUSE_ENABLED
    self.pauseState = nil;
#endif

    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPStep *step = [[XPStep allocWithZone:zone] init];
    step.axis = _axis;
    step.nodeTest = _nodeTest;
    step.range = _range;
    step.baseRange = _baseRange;
    
#if PAUSE_ENABLED
    step.pauseState = _pauseState;
#endif
    
    // don't copy filters.
    return step;
}


- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@::%@", XPAxisName[_axis], _nodeTest];
    for (XPExpression *f in _allFilters) {
        [str appendFormat:@"[%@]", f];
    }
    return [[str copy] autorelease];
}


- (XPStep *)addFilter:(XPExpression *)expr {
    XPAssert(expr);
    if (!_allFilters) {
        self.allFilters = [NSMutableArray arrayWithCapacity:2];
    }
    [_allFilters addObject:expr];
    
    XPPauseState *state = [[[XPPauseState alloc] init] autorelease];
    state.expression = expr;

    return self;
}


/**
 * Simplify the step. Return either the same step after simplification, or null,
 * indicating that the step will always give an empty result.
 */

- (XPStep *)simplify {
    
    NSUInteger c = [_allFilters count];
    NSUInteger i = c - 1;
    for (XPExpression *exp in [_allFilters reverseObjectEnumerator]) {
        exp = [exp simplify];
        _allFilters[i] = exp;
        
        // look for a filter that is constant true or false (which can arise after
        // an expression is reduced).
        
        if ([exp isValue] && ![(id)exp isNumericValue]) {
            if ([(id)exp asBoolean]) {
                // filter is constant true
                // only bother removing it if it's the last
                if (i == c-1) {
                    [_allFilters removeObjectAtIndex:i];
                }
            } else {
                // filter is constant false,
                // so the wbole path-expression is empty
                return nil;
            }
        }
        
        // look for the filter [last()]
//        if (exp instanceof Last) {
//            filters[i] = new IsLastExpression(true);
//        }

        --i;
    }
    
    return self;
}


/**
 * Enumerate this step.
 * @param node: The node from which we want to make the step
 * @param context: The context for evaluation. Affects the result of positional
 * filters
 * @return: an enumeration of nodes that result from applying this step
 */

- (id <XPSequenceEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx parent:(XPExpression *)expr {
    id <XPSequenceEnumeration>enm = [node enumerationForAxis:_axis nodeTest:_nodeTest];

#if PAUSE_ENABLED
    if (ctx.staticContext.debug) {
        [_pauseState addContextNode:node];
        
        if ([enm conformsToProtocol:@protocol(XPPauseHandler)]) {
            [_pauseState addResultNodes:[(id <XPPauseHandler>)enm currentResultNodes]];
        }

        _pauseState.expression = expr;
        _pauseState.range = self.baseRange;
        [self pause:_pauseState context:ctx];
    }
#endif

    if ([enm hasMoreItems]) {       // if there are no nodes, there's nothing to filter
        for (XPExpression *filter in _allFilters) {
            enm = [[[XPFilterEnumerator alloc] initWithBase:enm filter:filter context:ctx finishAfterReject:NO] autorelease];
        }
    }

    return enm;
}


#if PAUSE_ENABLED
- (void)pause:(XPPauseState *)state context:(XPContext *)ctx {
    XPAssert(state);
    [ctx.staticContext pauseFrom:state done:NO];
}
#endif


- (NSArray *)filters {
    return [[_allFilters copy] autorelease];
}


- (NSUInteger)numberOfFilters {
    return [_allFilters count];
}

@end
