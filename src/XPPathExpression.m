//
//  XPPathExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPPathExpression.h"
#import "XPContext.h"
#import "XPStep.h"
#import "XPAxis.h"
#import "XPEmptyNodeSet.h"
#import "XPAxisExpression.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPLocalOrderComparer.h"

@interface XPExpression ()
@property (nonatomic, retain, readwrite) id <XPStaticContext>staticContext;
@end

///**
// * Inner class PathEnumeration
// */
//@interface XPPathEnumeration : NSObject <XPNodeEnumeration>
//- (instancetype)initWithPathExpression:(XPPathExpression *)pathExpr start:(XPExpression *)start context:(XPContext *)ctx;
//
////
////    private Expression thisStart;
////    private NodeEnumeration base=null;
////    private NodeEnumeration thisStep=null;
////    private NodeInfo next=null;
////    private Context context;
//@property (nonatomic, assign) XPPathExpression *pathExpr; // weakref
//@property (nonatomic, retain) XPExpression *thisStart;
//@property (nonatomic, retain) id <XPNodeEnumeration>base;
//@property (nonatomic, retain) id <XPNodeEnumeration>thisStep;
//@property (nonatomic, retain) id <XPNodeInfo>next;
//@property (nonatomic, retain) XPContext *context;
//@end
//
//@implementation XPPathEnumeration
//
//- (instancetype)initWithPathExpression:(XPPathExpression *)pathExpr start:(XPExpression *)start context:(XPContext *)ctx {
//    self = [super init];
//    if (self) {
//        self.pathExpr = pathExpr;
//        self.thisStart = start;
//        self.context = [[ctx copy] autorelease];
//        self.base = [start enumerateInContext:self.context sorted:NO];
//        self.next = [self nextNode];
//    }
//    return self;
//}
//
//
//- (void)dealloc {
//    self.thisStart = nil;
//    self.base = nil;
//    self.thisStep = nil;
//    self.next = nil;
//    self.context = nil;
//    [super dealloc];
//}
//
//
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
//    NSUInteger count = 0;
//    
//    id <XPNodeInfo>node = nil;
//    
//    if (0 == state->state) {
//        node = [self nextObject];
//    } else {
//        node = (id <XPNodeInfo>)state->state;
//    }
//    
//    while ([self hasMoreObjects] && count < len) {
//        stackbuf[count] = node;
//        node = [self nextObject];
//        count++;
//    }
//    
//    state->state = (unsigned long)node;
//    state->itemsPtr = stackbuf;
//    state->mutationsPtr = (unsigned long *)self;
//    
//    return count;
//}
//
//
//- (BOOL)isSorted {
//    return YES;
//}
//
//
//- (BOOL)isReverseSorted {
//    return YES;
//}
//
//
//- (BOOL)isPeer {
//    return YES;
//}
//
//
//- (BOOL)hasMoreObjects {
//    return NO;
//}
//
//
//- (id <XPNodeInfo>)nextObject {
//    return nil;
//}
//
//
//- (NSUInteger)lastPosition {
//    return 0;
//}
//
//
////
////    public PathEnumeration(Expression start, Context context) throws XPathException {
////    }
////
////    public boolean hasMoreElements() {
////        return next!=null;
////    }
////
////    public NodeInfo nextElement() throws XPathException {
////        NodeInfo curr = next;
////        next = getNextNode();
////        return curr;
////    }
////
//- (id <XPNodeInfo>)nextNode {
//
//    // if we are currently processing a step, we continue with it. Otherwise,
//    // we get the next base element, and apply the step to that.
//
//    if (_thisStep && [_thisStep hasMoreObjects]) {
//        return [_thisStep nextObject];
//        //NodeInfo n = thisStep.nextElement();
//        //System.err.println("Continuing Step.nextElement() = " + n);
//        //return n;
//    }
//
//    while ([_base hasMoreObjects]) {
//        id <XPNodeInfo>node = [_base nextObject];
//        //System.err.println("Base.nextElement = " + node);
//        
//        XPAssert(_pathExpr.step);
//        self.thisStep = [_pathExpr.step enumerate:node inContext:_context];
//        if ([_thisStep hasMoreObjects]) {
//            return [_thisStep nextObject];
//            //NodeInfo n2 = thisStep.nextElement();
//            //System.err.println("Starting Step.nextElement() = " + n2);
//            //return n2;
//        }
//    }
//
//    return nil;
//}
////
////    /**
////     * Determine if we can guarantee that the nodes are in document order. This is true if the
////     * start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
////     * It is also true if the start is a singleton node and the axis is sorted.
////     */
////
////    public boolean isSorted() {
////        byte axis = step.getAxis();
////        return Axis.isForwards[axis] && (
////                                         ( (thisStart instanceof SingletonExpression) ||
////                                          (base.isSorted() && base.isPeer() && Axis.isSubtreeAxis[axis]) ||
////                                          (base.isSorted() && (axis==Axis.ATTRIBUTE || axis==Axis.NAMESPACE))
////                                          ));
////    }
////
////    /**
////     * Determine if the nodes are guaranteed to be in reverse document order. This is true if the
////     * base is singular (e.g. the root node or the current node) and the axis is a reverse axis
////     */
////
////    public boolean isReverseSorted() {
////        return thisStart instanceof SingletonExpression && Axis.isReverse[step.getAxis()];
////    }
////
////    /**
////     * Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
////     * other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
////     */
////
////    public boolean isPeer() {
////        return (base.isPeer() && Axis.isPeerAxis[step.getAxis()]);
////    }
////
////}   // end of inner class PathEnumeration
//@end

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
        NSUInteger dep = _start.dependencies;
        
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

- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    XPAssert(_start);
    XPAssert(_step);
    
    XPExpression *path = self;
    if ((dep & self.dependencies) != 0) {
        XPExpression *newstart = [_start reduceDependencies:dep inContext:ctx];
        XPStep *newstep = [[[XPStep alloc] initWithAxis:_step.axis nodeTest:_step.nodeTest] autorelease];

        NSUInteger removedep = dep & XPDependenciesXSLTContext;
//        if (_start.isContextDocumentNodeSet &&
//            ((dep & XPDependenciesContextDocument) != 0)) {
//            removedep |= XPDependenciesContextDocument;
//        }
//        
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
//
//    // Pre-evaluate an expression if the start is now a constant node-set
//    // (this will evaluate to a NodeSetIntent, which will be replaced by
//    // the corresponding node-set extent if it is used more than thrice).
//    
//    if (([path isKindOfClass:[XPPathExpression class]]) && [((XPPathExpression *)path).start isKindOfClass:[XPNodeSetValue class]]) {
        //return ((XPPathExpression *)path).start;
        //return [[[XPNodeSetIntent alloc] initWithNodeSetExpression:(XPPathExpression *)path controller:ctx.controller] autorelease];
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
    
    ctx = [[ctx copy] autorelease];
    
    id <XPNodeEnumeration>contextNodeEnm = [_start enumerateInContext:ctx sorted:sorted];
    
    id <XPNodeInfo>contextNode = nil;
    NSUInteger contextSize = 0;
    NSUInteger contextPosition = 0;
    
    if ([contextNodeEnm conformsToProtocol:@protocol(XPLastPositionFinder)]) {
        contextSize = [(id <XPLastPositionFinder>)contextNodeEnm lastPosition];
    } else {
        XPAssert(0); // TODO determine last position finder
    }
    
    ctx.last = contextSize;
    ctx.position = 0;
    
    NSMutableArray *resultUnion = [NSMutableArray array];
    
    while ([contextNodeEnm hasMoreObjects]) {
        contextNode = [contextNodeEnm nextObject];
        ++contextPosition;

        ctx.contextNode = contextNode;
        ctx.position = contextPosition;

        id <XPNodeEnumeration>enm = [_step enumerate:contextNode inContext:ctx];
        
        for (id <XPNodeInfo>node in enm) {
            [resultUnion addObject:node];
        }
    }

    XPNodeSetValue *nodeSet = [[[XPNodeSetValue alloc] initWithNodes:resultUnion comparer:[XPLocalOrderComparer instance]] autorelease];
    id <XPNodeEnumeration>enm = [nodeSet enumerateInContext:ctx sorted:sorted];
    
    
    
//    NSUInteger actualdep = self.dependencies;
//    NSUInteger removedep = 0;
//    
//    if ((actualdep & XPDependenciesXSLTContext) != 0) {
//        removedep |= XPDependenciesXSLTContext;
//    }
//    
//    if (_start.isContextDocumentNodeSet &&
//        ((actualdep & XPDependenciesContextDocument) != 0)) {
//        removedep |= XPDependenciesContextDocument;
//    }
//    
//    if ((removedep & (XPDependenciesXSLTContext | XPDependenciesContextDocument)) != 0) {
//        XPExpression *temp = [self reduceDependencies:removedep inContext:ctx];
//        return [temp enumerateInContext:ctx sorted:sorted];
//    }
    
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
