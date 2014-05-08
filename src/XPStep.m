//
//  XPStep.m
//  XPath
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPStep.h"
#import "XPNodeTest.h"
#import <XPath/XPExpression.h>
#import <XPath/XPValue.h>
#import <XPath/XPNodeInfo.h>
#import "XPAxisEnumeration.h"
#import "XPFilterEnumeration.h"

@interface XPStep ()
@property (nonatomic, retain) NSMutableArray *allFilters;
@end

@implementation XPStep

- (instancetype)initWithAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    self = [super init];
    if (self) {
        self.axis = axis;
        self.nodeTest = nodeTest;
    }
    return self;
}


- (void)dealloc {
    self.nodeTest = nil;
    self.allFilters = nil;
    
    [super dealloc];
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
    XPAssert(_allFilters);
    [_allFilters addObject:expr];
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

- (id <XPNodeEnumeration>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx {
    id <XPNodeEnumeration>enm = [node enumerationForAxis:_axis nodeTest:_nodeTest];

    if ([enm hasMoreObjects]) {       // if there are no nodes, there's nothing to filter
        for (XPExpression *filter in _allFilters) {
            
            enm = [[[XPFilterEnumeration alloc] initWithBase:enm filter:filter context:ctx finishAfterReject:NO] autorelease];
        }
    }

    return enm;
}


- (NSArray *)filters {
    return [[_allFilters copy] autorelease];
}


- (NSUInteger)numberOfFilters {
    return [_allFilters count];
}

@end
