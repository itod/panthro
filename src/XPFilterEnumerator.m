//
//  XPFilterEnumeration.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPFilterEnumerator.h"
#import "XPNodeEnumeration.h"
#import "XPExpression.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPNumericValue.h"
#import "XPPositionRange.h"
#import "XPLastPositionFinder.h"

@interface XPFilterEnumerator ()
@property (nonatomic, retain) id <XPNodeEnumeration>base;
@property (nonatomic, retain) XPExpression *filter;

@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, assign) NSUInteger last;

@property (nonatomic, assign) NSUInteger min;
@property (nonatomic, assign) NSUInteger max;

@property (nonatomic, retain) id <XPNodeInfo>current;
@property (nonatomic, retain) XPContext *filterContext;

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

- (instancetype)initWithBase:(id <XPNodeEnumeration>)base filter:(XPExpression *)filter context:(XPContext *)ctx finishAfterReject:(BOOL)finishAfterReject {
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
            XPAssert(0);
            //self.base = new LookaheadEnumerator(base);
            [_filterContext setLastPositionFinder:(id <XPLastPositionFinder>)_base];
        }
        
        self.current = [self nextMatchingObject];

    }
    return self;
}


/**
 * Test whether there are any more nodes available in the enumeration
 */

- (BOOL)hasMoreObjects {
    if (_finished) return NO;
    return _current != nil;
}


/**
 * Get the next node if there is one
 */

- (id <XPNodeInfo>)nextObject {
    //XPAssert(_current);
    id <XPNodeInfo>node = _current;
    self.current = [self nextMatchingObject];
    return node;
}


/**
 * Get the next node that matches the filter predicate if there is one
 */

- (id <XPNodeInfo>)nextMatchingObject {
    while (!_finished && [_base hasMoreObjects]) {
        id <XPNodeInfo>next = [_base nextObject];
        self.position++;
        if ([self matches:next]) {
            return next;
        } else if (_finishAfterReject) {
            return nil;
        }
    }
    return nil;
}

/**
 * Determine whether a node matches the filter predicate
 */

- (BOOL)matches:(id <XPNodeInfo>)node {
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
    _filterContext.contextNode = node;
    
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
    return [_base isSorted];
}


- (BOOL)isReverseSorted {
    return [_base isReverseSorted];
}


/**
 * Determine whether the nodes are guaranteed to be peers
 */

- (BOOL)isPeer {
    return [_base isPeer];
}

@end
