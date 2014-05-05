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

@interface XPStep ()
@property (nonatomic, retain, readwrite) NSMutableArray *filters;
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
    self.filters = nil;
    
    [super dealloc];
}


- (XPStep *)addFilter:(XPExpression *)expr {
    XPAssert(expr);
    if (!_filters) {
        self.filters = [NSMutableArray arrayWithCapacity:2];
    }
    XPAssert(_filters);
    [_filters addObject:expr];
    return self;
}


/**
 * Simplify the step. Return either the same step after simplification, or null,
 * indicating that the step will always give an empty result.
 */

- (XPStep *)simplify {
    XPAssert(_filters);
    
    NSUInteger c = [_filters count];
    NSUInteger i = c - 1;
    for (XPExpression *exp in [[[_filters copy] autorelease] reverseObjectEnumerator]) {
        exp = [exp simplify];
        _filters[i] = exp;
        
        // look for a filter that is constant true or false (which can arise after
        // an expression is reduced).
        
        if ([exp isValue] && ![(id)exp isNumericValue]) {
            if ([(id)exp asBoolean]) {
                // filter is constant true
                // only bother removing it if it's the last
                if (i == c-1) {
                    [_filters removeObjectAtIndex:i];
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
    id <XPAxisEnumeration>enm = [node EnumerationForAxis:_axis nodeTest:_nodeTest];
    if ([enm hasMoreElements]) {       // if there are no nodes, there's nothing to filter

        //TODO
//        for (XPExpression *filter in _filters) {
//            enm = [[[XPFilterEnumeration EnumerationWithEnumeration:enm filter:filter context:ctx bool:NO] autorelease];
//        }
    }
    return enm;
    
}


- (NSUInteger)numberOfFilters {
    return [self.filters count];
}


/**
 * Diagnostic print of expression structure
 */

- (void)display:(NSInteger)level {
    XPAssert(0);
//    System.err.println(Expression.indent(level) + "Step " + Axis.axisName[axis] + "::" + test.toString() +
//                       (numberOfFilters > 0 ? " [" : ""));
//    for (int f=0; f<numberOfFilters; f++) {
//        filters[f].display(level+1);
//    }
}

@end
