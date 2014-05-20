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
#import "XPStep.h"
#import "XPAxis.h"
#import "XPEmptyNodeSet.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPLookaheadEnumerator.h"
#import "XPFilterEnumerator.h"
#import "XPLocalOrderComparer.h"
#import "XPSingletonNodeSet.h"

@interface XPExpression ()
@property (nonatomic, retain, readwrite) id <XPStaticContext>staticContext;
@end

@implementation XPPathExpression

/**
 * Constructor
 * @param start A node-set expression denoting the absolute or relative set of nodes from which the
 * navigation path should start.
 * @param step The step to be followed from each node in the start expression to yield a new
 * node-set
 */

- (instancetype)initWithStart:(XPExpression *)start step:(XPStep *)step {
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


- (NSString *)description {
    return [NSString stringWithFormat:@"%@/%@", _start, _step];
}


/**
 * Simplify an expression
 * @return the simplified expression
 */

- (XPExpression *)simplify {
    self.start = [_start simplify];
    self.step = [_step simplify];
    
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
    
    XPExpression *path = self;
    if ((dep & self.dependencies) != 0) {
        XPExpression *newstart = [_start reduceDependencies:dep inContext:ctx];
        XPStep *newstep = [[[XPStep alloc] initWithAxis:_step.axis nodeTest:_step.nodeTest] autorelease];

        NSUInteger removedep = dep & XPDependenciesXSLTContext;
        if ([_start isContextDocumentNodeSet] && ((dep & XPDependenciesContextDocument) != 0)) {
            removedep |= XPDependenciesContextDocument;
        }
        
        for (XPExpression *expr in _step.filters) {
            // Not all dependencies in the filter matter, because the context node, etc,
            // are not dependent on the outer context of the PathExpression
            XPExpression *newfilter = [expr reduceDependencies:removedep inContext:ctx];
            [newstep addFilter:newfilter];
        }
        
        path = [[[XPPathExpression alloc] initWithStart:newstart step:newstep] autorelease];
        path.staticContext = self.staticContext;
        path = [path simplify];
    }

//    // Pre-evaluate an expression if the start is now a constant node-set
//    // (this will evaluate to a NodeSetIntent, which will be replaced by
//    // the corresponding node-set extent if it is used more than thrice).
//    
//    if (([path isKindOfClass:[XPPathExpression class]]) && [((XPPathExpression *)path).start isKindOfClass:[XPNodeSetValue class]]) {
//        return ((XPPathExpression *)path).start;
//        //return [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPPathExpression *)path controller:ctx.controller] autorelease];
//    }
    
    return path;
}


/**
 * Evaluate the path-expression in a given context to return a NodeSet
 * @param context the evaluation context
 * @param sort true if the returned nodes must be in document order
 */
- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
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
    
    id <XPNodeEnumeration>ctxNodeEnm = [_start enumerateInContext:ctx sorted:sorted];
    
    ctx = [[ctx copy] autorelease];
    ctx.position = 0;
    
    if ([ctxNodeEnm conformsToProtocol:@protocol(XPLastPositionFinder)]) {
        ctx.lastPositionFinder = (id <XPLastPositionFinder>)ctxNodeEnm;
    } else {
        ctx.lastPositionFinder = [[[XPLookaheadEnumerator alloc] initWithBase:ctxNodeEnm] autorelease];
    }
    
    NSMutableArray *resultUnion = [NSMutableArray array];

    while ([ctxNodeEnm hasMoreObjects]) {
        
        ++ctx.position;
        ctx.contextNode = [ctxNodeEnm nextObject];

        id <XPNodeEnumeration>enm = [_step enumerate:ctx.contextNode inContext:ctx];
        
        for (id <XPNodeInfo>node in enm) {
            [resultUnion addObject:node];
        }

    }

    XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithNodes:resultUnion comparer:[XPLocalOrderComparer instance]] autorelease];
    
    if (ctx.staticContext.debug) {
        [ctx.staticContext.debugSync putPauseInfo:@{@"contextNode": ctx.contextNode, @"result": nodeSet, @"done": @NO}];
        [ctx.staticContext.debugSync takeResumeInfo];

        BOOL resume = YES;
        if (!resume) {
            [NSException raise:@"XPathTerminateException" format:@"User Terminated"];
        }
    }
    
    // always sort after the curruent step has completed to remove dupes and place nodes in document order.
    id <XPNodeEnumeration>enm = [nodeSet enumerateInContext:ctx sorted:YES];
    
    
    
    
//    id <XPNodeEnumeration>enm = [[[XPPathEnumeration alloc] initWithPathExpression:self start:_start context:ctx] autorelease];
//    if (sorted && !enm.isSorted) {
//
//        id <XPNodeOrderComparer>comparer = nil;
//        
//        if ([_start isKindOfClass:[XPSingletonNodeSet class]] || _start.isContextDocumentNodeSet) {
//            // nodes are all in the same document
//            comparer = [XPLocalOrderComparer instance];
//        } else {
//            comparer = ctx.controller;
//        }
//        XPNodeSetExtent *ns = [[[XPNodeSetExtent alloc] initWithNodeEnumeration:enm controller:comparer] autorelease];
//        [ns sort];
//        return [ns enumerate];
//    }
    return enm;
}


- (XPDataType)dataType {
    return XPDataTypeNodeSet;
}

@end
