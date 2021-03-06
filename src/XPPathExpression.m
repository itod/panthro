//
//  XPPathExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPPathExpression.h"
#import "XPStaticContext.h"
#import "XPSync.h"
#import "XPContext.h"
#import "XPException.h"
#import "XPAxisStep.h"
#import "XPAxis.h"
#import "XPLocalOrderComparer.h"

#import "XPPathEnumeration.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPLookaheadEnumerator.h"
#import "XPFilterEnumerator.h"

//#import "XPNodeSetIntent.h"
#import "XPNodeSetExtent.h"

#import "XPSingletonNodeSet.h"
#import "XPEmptyNodeSet.h"

#import "XPRootExpression.h"
#import "XPContextNodeExpression.h"

#import "XPAxisExpression.h"

@implementation XPPathExpression

/**
 * Constructor
 * @param start A node-set expression denoting the absolute or relative set of nodes from which the
 * navigation path should start.
 * @param step The step to be followed from each node in the start expression to yield a new
 * node-set
 */

- (instancetype)initWithStart:(XPExpression *)start step:(XPExpression *)step {
    self = [super init];
    if (self) {
        self.dependencies = XPDependenciesInvalid;
        self.start = start;
        self.step = step;
    }
    return self;
}


- (void)dealloc {
    self.start = nil;
    self.step = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPPathExpression *expr = [super copyWithZone:zone];
    expr.dependencies = _dependencies;
    expr.start = [[_start copy] autorelease];
    expr.step = [[_step copy] autorelease];
    return expr;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@/%@", _start, _step];
}


- (BOOL)isAxisStep {
    return [_step isKindOfClass:[XPAxisStep class]];
}


/**
 * Simplify an expression
 * @return the simplified expression
 */

- (XPExpression *)simplify {
    self.start = [_start simplify];
    self.step = [_step simplify];

    if ([_start isKindOfClass:[XPEmptyNodeSet class]]) {
        return _start;
    }
        
    if (!_step) {
        return [XPEmptyNodeSet instance];
    }
    
    if ([self isAxisStep]) {
        XPAxis axis = [(XPAxisStep *)_step axis];
        
        // the expression /.. is sometimes used to represent the empty node-set
        if ([_start isKindOfClass:[XPRootExpression class]] && axis == XPAxisParent) {
            XPExpression *expr = [XPEmptyNodeSet instance];
            expr.staticContext = self.staticContext;
            expr.range = self.range;
            return expr;
        }
    }
    
//    if ([_start isKindOfClass:[XPContextNodeExpression class]] &&
//        0 == _step.numberOfFilters) {
//        XPExpression *expr = [[[XPAxisExpression alloc] initWithAxis:axis nodeTest:_step.nodeTest] autorelease];
//        expr.staticContext = self.staticContext;
//        expr.range = self.range;
//        return expr;
//    }
    
    XPAssert(_start);
    XPAssert(_step);
    return self;
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    XPAssert(_start);
    XPAssert(_step);
    
    if (XPDependenciesInvalid == _dependencies) {
        XPDependencies dep = _start.dependencies;
        
        for (XPExpression *expr in _step.filters) {
            // Not all dependencies in the filter matter, because the context node, etc,
            // are not dependent on the outer context of the PathExpression
            dep |= (expr.dependencies & XPDependenciesXSLTContext);
            //(Context.XSLT_CONTEXT | XPDependenciesContextDocument));
        }
        
        self.dependencies = dep;
    }
    return _dependencies;
}


/**
 * Determine, in the case of an expression whose data type is Value.NODESET,
 * whether all the nodes in the node-set are guaranteed to come from the same
 * document as the context node. Used for optimization.
 */

- (BOOL)isContextDocumentNodeSet {
    XPAssert(_start);
    return [_start isContextDocumentNodeSet];
}

/**
 * Perform a partial evaluation of the expression, by eliminating specified dependencies
 * on the context.
 * @param dep The dependencies to be removed
 * @param context The context to be used for the partial evaluation
 * @return a new expression that does not have any of the specified
 * dependencies
 */

- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPAssert(_start);
    XPAssert(_step);
    
    XPExpression *result = self;
    if ((self.dependencies & dep) != 0) {
        XPExpression *newstart = [_start reduceDependencies:dep inContext:ctx];
        XPExpression *newstep = [[_step copy] autorelease];
        [newstep removeAllFilters];

        NSUInteger removedep = dep & XPDependenciesXSLTContext;
        if (_start.isContextDocumentNodeSet && ((dep & XPDependenciesContextDocument) != 0)) {
            removedep |= XPDependenciesContextDocument;
        }
        
        for (XPExpression *expr in _step.filters) {
            // Not all dependencies in the filter matter, because the context node, etc,
            // are not dependent on the outer context of the PathExpression
            XPExpression *newfilter = [expr reduceDependencies:removedep inContext:ctx];
            [newstep addFilter:newfilter];
        }
        
        XPAssert(newstart);
        XPAssert(newstep);
        result = [[[XPPathExpression alloc] initWithStart:newstart step:newstep] autorelease];
        result.staticContext = self.staticContext;
        result.range = self.range;
        result = [result simplify];
    }

    // Pre-evaluate an expression if the start is now a constant node-set
    // (this will evaluate to a NodeSetIntent, which will be replaced by
    // the corresponding node-set extent if it is used more than thrice).
    
//    if (([result isKindOfClass:[XPPathExpression class]]) && [((XPPathExpression *)result).start isKindOfClass:[XPNodeSetValue class]]) {
//        XPNodeSetIntent *nsi = [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPPathExpression *)result comparer:nil] autorelease];
//        nsi.staticContext = self.staticContext;
//        nsi.range = result.range;
//        return nsi;
//    }

    return result;
}


/**
 * Evaluate the path-expression in a given context to return a NodeSet
 * @param context the evaluation context
 * @param sort true if the returned nodes must be in document order
 */
- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    // if the expression references variables, or depends on other aspects of
    // the XSLT context, then resolve these dependencies now. Also, if the nodes
    // are all known to be in the context document, then any dependency on the
    // context document (e.g. an absolute path expression in a predicate) can also
    // be removed now.
    NSUInteger actualdep = self.dependencies;
    NSUInteger removedep = 0;
    
    if ((actualdep & XPDependenciesXSLTContext) != 0) {
        removedep |= XPDependenciesXSLTContext;
    }
    
    if ([_start isContextDocumentNodeSet] && ((actualdep & XPDependenciesContextDocument) != 0)) {
        removedep |= XPDependenciesContextDocument;
    }
    
    if ((removedep & (XPDependenciesXSLTContext | XPDependenciesContextDocument)) != 0) {
        XPExpression *temp = [self reduceDependencies:removedep inContext:ctx];
        return [temp enumerateInContext:ctx sorted:sorted];
    }

    // ok, here we are.
    
    id <XPSequenceEnumeration>enm = [[[XPPathEnumeration alloc] initWithStart:_start step:_step context:ctx] autorelease];
    if (sorted && !enm.isSorted) {
        
        id <XPNodeOrderComparer>comparer = nil;
        
        if ([_start isKindOfClass:[XPSingletonNodeSet class]] || [_start isContextDocumentNodeSet]) {
            // nodes are all in the same document
            comparer = [XPLocalOrderComparer instance];
        } else {
            //comparer = ctx.controller;
            //XPAssert(0);
        }
        
        XPNodeSetValue *ns = [[[XPNodeSetExtent alloc] initWithEnumeration:enm comparer:comparer] autorelease];
        [ns sort];
        
        enm = [ns enumerate];
    }

    return enm;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
