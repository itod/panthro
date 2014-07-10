//
//  XPFilterEnumeration.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPFilterEnumerator.h"
#import "XPSequenceEnumeration.h"
#import "XPExpression.h"
#import "XPNodeInfo.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPNumericValue.h"
#import "XPPositionRange.h"
#import "XPLastPositionFinder.h"
#import "XPLookaheadEnumerator.h"

#if PAUSE_ENABLED
#import "XPStaticContext.h"
#import "XPNodeSetExtent.h"
#import "XPPauseState.h"
#endif

@interface XPFilterEnumerator ()
@property (nonatomic, retain) id <XPSequenceEnumeration>base;
@property (nonatomic, retain) XPExpression *filter;

@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, assign) NSUInteger last;

@property (nonatomic, assign) NSUInteger min;
@property (nonatomic, assign) NSUInteger max;

@property (nonatomic, retain) id <XPItem>current;

@property (nonatomic, assign) XPDataType dataType;
@property (nonatomic, assign) BOOL positional;
@property (nonatomic, assign) BOOL finished; // allows early finish with a numeric filter
@property (nonatomic, assign) BOOL finishAfterReject; // causes enumeration to terminate the first time the predicate is false
@end

@implementation XPFilterEnumerator

/**
 * Constructor
 * @param base A node-set expression denoting the absolute or relative set of nodes from which the
 * navigation path should start.
 * @param filter The expression defining the filter predicate
 * @param context The context in which the expression is being evaluated
 * @param finishAfterReject: terminate enumeration on first failure
 */

- (instancetype)initWithBase:(id <XPSequenceEnumeration>)base filter:(XPExpression *)filter context:(XPContext *)ctx finishAfterReject:(BOOL)finishAfterReject {
    self = [super init];
    if (self) {
        self.position = 0;
        self.last = NSNotFound;
        self.min = 1;
        self.max = NSUIntegerMax;
        self.dataType = XPDataTypeAny;
        
        self.base = base;
        self.filter = filter;
        self.finishAfterReject = finishAfterReject;
        
        self.filterContext = [[ctx copy] autorelease];
        
        self.dataType = filter.dataType;

#if PAUSE_ENABLED
        self.pauseState = [[[XPPauseState alloc] init] autorelease];
#endif

        if ([_filter isKindOfClass:[XPNumericValue class]]) {
            // if value is not an integer, it will never match
            double pos = [(XPNumericValue *)_filter asNumber];
            if (floor(pos) == pos) {
                self.min = lround(floor(pos));
                self.max = _min;
                self.positional = YES;
            } else {
                self.finished = YES;
            }
        } else if ([_filter isKindOfClass:[XPPositionRange class]]) {
            self.min = [(XPPositionRange *)_filter minPosition];
            self.max = [(XPPositionRange *)_filter maxPosition];
            self.positional = YES;
        }
        
        if ([_base conformsToProtocol:@protocol(XPLastPositionFinder) ]) {
            [_filterContext setLastPositionFinder:(id <XPLastPositionFinder>)_base];
        } else {
            // TODO: only need to do this if last() is used in the predicate
            self.base = [[[XPLookaheadEnumerator alloc] initWithBase:base] autorelease];
            [_filterContext setLastPositionFinder:(id <XPLastPositionFinder>)_base];
        }
        
        self.current = [self nextMatchingItem];

    }
    return self;
}


- (void)dealloc {
    self.base = nil;
    self.filter = nil;
    self.current = nil;
    self.filterContext = nil;

#if PAUSE_ENABLED
    self.pauseState = nil;
#endif
    
    [super dealloc];
}


#pragma mark -
#pragma mark XPPauseHandler

- (NSArray *)currentResultNodes {
    NSArray *result = nil;
    if ([_base conformsToProtocol:@protocol(XPPauseHandler)]) {
        result = [(id <XPPauseHandler>)_base currentResultNodes];
    }
    return result;
}


/**
 * Test whether there are any more nodes available in the enumeration
 */

- (BOOL)hasMoreItems {
    if (_finished) return NO;
    BOOL res = _current != nil;
    return res;;
}


/**
 * Get the next node if there is one
 */

- (id <XPItem>)nextItem {
    //XPAssert(_current);
    id <XPItem>node = _current;
    self.current = [self nextMatchingItem];
    
//#if PAUSE_ENABLED
//    if (![self hasMoreItems]) {
//        [self pause];
//    }
//#endif
    
    return node;
}


/**
 * Get the next node that matches the filter predicate if there is one
 */

- (id <XPItem>)nextMatchingItem {
    id <XPItem>result = nil;

#if PAUSE_ENABLED
    BOOL debug = _filterContext.staticContext.debug;
    _filterContext.staticContext.debug = NO;
#endif
    
    while (!_finished && [_base hasMoreItems]) {
        id <XPItem>next = [_base nextItem];
        self.position++;
        if ([self matches:next]) {
            
#if PAUSE_ENABLED
            if (debug) {
                [_pauseState addContextNode:_filterContext.contextNode];
                [_pauseState addResultNodes:@[next]];
            }
#endif
            
            result = next;
            break;
        } else if (_finishAfterReject) {
            result = nil;
            break;
        }
    }

#if PAUSE_ENABLED
    _filterContext.staticContext.debug = debug;
#endif

    return result;
}


//#if PAUSE_ENABLED
//- (void)pause {
//    XPAssert(_pauseState);
//    XPSequenceValue *contextNodeSet = [[[[XPNodeSetExtent alloc] initWithNodes:[_pauseState contextNodes] comparer:nil] autorelease] sort];
//    
//    XPSequenceValue *resultNodeSet = [[[[XPNodeSetExtent alloc] initWithNodes:[_pauseState resultNodes] comparer:nil] autorelease] sort];
//    
//    [_filterContext.staticContext pauseFrom:_filter withContextNodes:contextNodeSet result:resultNodeSet range:_filter.range done:NO];
//}
//#endif


/**
 * Determine whether a node matches the filter predicate
 */

- (BOOL)matches:(id <XPItem>)node {
    if (_positional) {
        if (_position < _min) {
            return NO;
        } else if (_position > _max) {
            self.finished = YES;
            return NO;
        } else {
            return YES;
        }
    }
    _filterContext.position = _position;
    _filterContext.contextNode = (id)node;
    
    // If the data type is known at compile time, and cannot be numeric,
    // evaluate the expression directly as a boolean. This avoids expanding
    // a node-set unnecessarily.
    
    if (_dataType == XPDataTypeNumber) {
        double req = round([_filter evaluateAsNumberInContext:_filterContext]);
        if ((double)_position == req) {
            return YES;
        } else {
            return NO;
        }
    } else if (_dataType == XPDataTypeAny) {
        // have to determine the data type at run-time
        XPValue *val = [_filter evaluateInContext:_filterContext];
        if ([val isNumericValue]) {
            return ((double)_position == [val asNumber]);
        } else {
            return [val asBoolean];
        }
    } else {
        // for any other type, evaluate the filter expression as a boolean
        return [_filter evaluateAsBooleanInContext:_filterContext];
    }
}


/**
 * Determine whether the nodes are guaranteed to be in document order
 */

- (BOOL)isSorted {
    return _base.isSorted;
}


- (BOOL)isReverseSorted {
    return _base.isReverseSorted;
}


/**
 * Determine whether the nodes are guaranteed to be peers
 */

- (BOOL)isPeer {
    return _base.isPeer;
}

@end
