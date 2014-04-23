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
#import "XPAxisEnumerator.h"

@interface XPStep ()
@property (nonatomic, assign) XPAxis axis;
@property (nonatomic, retain) XPNodeTest *nodeTest;
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

- (id <XPNodeEnumerator>)enumerate:(id <XPNodeInfo>)node inContext:(XPContext *)ctx {
    id <XPAxisEnumerator>enm = [node enumeratorForAxis:_axis nodeTest:_nodeTest];
    if ([enm hasMoreElements]) {       // if there are no nodes, there's nothing to filter

        //TODO
//        for (XPExpression *filter in _filters) {
//            enm = [[[XPFilterEnumerator enumeratorWithEnumerator:enm filter:filter context:ctx bool:NO] autorelease];
//        }
    }
    return enm;
    
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
