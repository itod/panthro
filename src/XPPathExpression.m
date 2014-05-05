//
//  XPPathExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/4/14.
//
//

#import "XPPathExpression.h"
#import "XPStep.h"
#import "XPAxis.h"
#import "XPEmptyNodeSet.h"
#import "XPAxisExpression.h"

#import "XPRootExpression.h"
//#import "XPContextNodeExpression.h"
//#import "XPAttributeReference.h"
//#import "XPAnyNodeTest.h"

@interface XPPathExpression ()
@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPStep *step;
@property (nonatomic, assign) NSUInteger dependencies;
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
        self.dependencies = NSNotFound;
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


/**
 * Simplify an expression
 * @return the simplified expression
 */

- (XPExpression *)simplify {
    
    self.start = [_start simplify];
    self.step = [_step simplify];
//
//    // if the start expression is an empty node-set, then the whole PathExpression is empty
//    if ([_start isKindOfClass:[XPEmptyNodeSet class]]) {
//        return _start;
//    }
//    
//    // if the simplified Step is null, then by convention the whole PathExpression is empty
//    if (!_step) {
//        return [[[XPEmptyNodeSet alloc] init] autorelease];
//    }
//    
//    XPAxis axis = [_step axis];
//    
//    // the expression /.. is sometimes used to represent the empty node-set
//    
//    if ([_start isKindOfClass:[XPRootExpression class]] && axis == XPAxisParent) {
//        return [[[XPEmptyNodeSet alloc] init] autorelease];
//    }
//    
//    // simplify a straightforward attribute reference such as "@name"
//    
//    if ([_start isKindOfClass:[XPContextNodeExpression class]] &&
//        axis == XPAxisAttribute &&
//        [[_step nodeTest] isKindOfClass:[XPNameTest class]] &&
//        0 == _step.numberOfFilters) {
//        
//        return new AttributeReference(step.getNodeTest().getFingerprint());
//    }
//    
//    // Simplify a path expression that starts at the context node and uses no
//    // filters.
//    
//    if ([_start isKindOfClass:[XPContextNodeExpression class]] && 0 == _step.numberOfFilters) {
//        return [[[XPAxisExpression alloc] initWithAxis:axis nodeTest:[_step nodeTest]] autorelease];
//    }
//    
//    // Simplify an expression of the form a//b, where b has no filters.
//    // This comes out of the parser as a/descendent-or-self::node()/child::b,
//    // but it is equivalent to a/descendant::b; and the latter is better as it
//    // doesn't require sorting
//    
//    if (XPAxisChild == axis &&
//        0 == _step.numberOfFilters &&
//        [_start isKindOfClass:[XPPathExpression class]] &&
//        ((XPPathExpression *)_start).step.axis == XPAxisDescendantOrSelf &&
//        ((XPPathExpression *)_start).step.numberOfFilters == 0 &&
//        [((XPPathExpression *)_start).step.nodeTest isKindOfClass:[XPAnyNodeTest class]])
//    {
//        // detect a simple "//name" expression
//        
//        // this optimisation is now done at run time by NodeImpl.getEnumeration()
//        // and TinyNodeImpl.getEnumeration()
//        
//        //Expression newstart = ((PathExpression)start).start;
//        //if ((newstart instanceof RootExpression) &&
//        //        (step.getNodeTest().getNodeType() == NodeInfo.ELEMENT) &&
//        //        (step.getNodeTest() instanceof NameTest)) {
//        //    return new AllElementsExpression(((NameTest)step.getNodeTest()).getFingerprint());
//        //
//        //} else {
//        
//        XPStep *newStep = [[[XPStep alloc] initWithAxis:XPAxisDescendant nodeTest:_step.nodeTest] autorelease];
//        return [[[XPPathExpression alloc] initWithStart:((XPPathExpression *)_start).start step:newStep] autorelease];
//        //}
//    }
    
    return self;
}

/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (NSUInteger)dependencies {
    XPAssert(_start);
    XPAssert(_step);
    
    if (NSNotFound == _dependencies) {
        NSUInteger dep = _start.dependencies;
        
        for (XPExpression *expr in _step.filters) {
            // Not all dependencies in the filter matter, because the context node, etc,
            // are not dependent on the outer context of the PathExpression
            dep |= (expr.dependencies & XPDependenciesXSLTContext);
            //(Context.XSLT_CONTEXT | Context.CONTEXT_DOCUMENT));
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

///**
// * Perform a partial evaluation of the expression, by eliminating specified dependencies
// * on the context.
// * @param dep The dependencies to be removed
// * @param context The context to be used for the partial evaluation
// * @return a new expression that does not have any of the specified
// * dependencies
// */
//
//public Expression reduce(int dep, Context context) throws XPathException {
//    Expression path = this;
//    if ((dep & getDependencies()) != 0) {
//        Expression newstart = start.reduce(dep, context);
//        Step newstep = new Step(step.getAxis(), step.getNodeTest());
//        Expression[] filters = step.getFilters();
//        
//        int removedep = dep & Context.XSLT_CONTEXT;
//        if (start.isContextDocumentNodeSet() &&
//            ((dep & Context.CONTEXT_DOCUMENT)!=0)) {
//            removedep |= Context.CONTEXT_DOCUMENT;
//        }
//        
//        for (int f=0; f<step.getNumberOfFilters(); f++) {
//            Expression exp = filters[f];
//            // Not all dependencies in the filter matter, because the context node, etc,
//            // are not dependent on the outer context of the PathExpression
//            Expression newfilter = exp.reduce(removedep, context);
//            newstep.addFilter(newfilter);
//        }
//        path = new PathExpression(newstart, newstep);
//        path.setStaticContext(getStaticContext());
//        path =  path.simplify();
//    }
//    
//    // Pre-evaluate an expression if the start is now a constant node-set
//    // (this will evaluate to a NodeSetIntent, which will be replaced by
//    // the corresponding node-set extent if it is used more than thrice).
//    
//    if ((path instanceof PathExpression) &&
//        ((PathExpression)path).start instanceof NodeSetValue) {
//        return new NodeSetIntent((PathExpression)path, context.getController());
//    }
//    
//    return path;
//}
//
//
///**
// * Evaluate the path-expression in a given context to return a NodeSet
// * @param context the evaluation context
// * @param sort true if the returned nodes must be in document order
// */
//
//public NodeEnumeration enumerate(Context context, boolean sort) throws XPathException {
//    // if the expression references variables, or depends on other aspects of
//    // the XSLT context, then resolve these dependencies now. Also, if the nodes
//    // are all known to be in the context document, then any dependency on the
//    // context document (e.g. an absolute path expression in a predicate) can also
//    // be removed now.
//    
//    int actualdep = getDependencies();
//    int removedep = 0;
//    
//    if ((actualdep & Context.XSLT_CONTEXT) != 0) {
//        removedep |= Context.XSLT_CONTEXT;
//    }
//    
//    if (start.isContextDocumentNodeSet() &&
//        ((actualdep & Context.CONTEXT_DOCUMENT) != 0)) {
//        removedep |= Context.CONTEXT_DOCUMENT;
//    }
//    
//    if (( removedep & (Context.XSLT_CONTEXT | Context.CONTEXT_DOCUMENT)) != 0) {
//        Expression temp = reduce(removedep, context);
//        return temp.enumerate(context, sort);
//    }
//    
//    NodeEnumeration enm = new PathEnumeration(start, context);
//    if (sort && !enm.isSorted()) {
//        NodeOrderComparer comparer;
//        if (start instanceof SingletonNodeSet || start.isContextDocumentNodeSet()) {
//            // nodes are all in the same document
//            comparer = LocalOrderComparer.getInstance();
//        } else {
//            comparer = context.getController();
//        }
//        NodeSetExtent ns = new NodeSetExtent(enm, comparer);
//        ns.sort();
//        return ns.enumerate();
//    }
//    return enm;
//}
//
///**
// * Diagnostic print of expression structure
// */
//
//public void display(int level) {
//    System.err.println(indent(level) + "path");
//    start.display(level+1);
//    step.display(level+1);
//}
//
//
///**
// * Inner class PathEnumeration
// */
//
//private class PathEnumeration implements NodeEnumeration {
//    
//    private Expression thisStart;
//    private NodeEnumeration base=null;
//    private NodeEnumeration thisStep=null;
//    private NodeInfo next=null;
//    private Context context;
//    
//    public PathEnumeration(Expression start, Context context) throws XPathException {
//        if (start instanceof SingletonNodeSet) {
//            if (!((SingletonNodeSet)start).isGeneralUseAllowed()) {
//                throw new XPathException("To use a result tree fragment in a path expression, either use exsl:node-set() or specify version='1.1'");
//            }
//        }
//        thisStart = start;
//        this.context = context.newContext();
//        base = start.enumerate(this.context, false);
//        next = getNextNode();
//    }
//    
//    public boolean hasMoreElements() {
//        return next!=null;
//    }
//    
//    public NodeInfo nextElement() throws XPathException {
//        NodeInfo curr = next;
//        next = getNextNode();
//        return curr;
//    }
//    
//    private NodeInfo getNextNode() throws XPathException {
//        
//        // if we are currently processing a step, we continue with it. Otherwise,
//        // we get the next base element, and apply the step to that.
//        
//        if (thisStep!=null && thisStep.hasMoreElements()) {
//            return thisStep.nextElement();
//            //NodeInfo n = thisStep.nextElement();
//            //System.err.println("Continuing Step.nextElement() = " + n);
//            //return n;
//        }
//        
//        while (base.hasMoreElements()) {
//            NodeInfo node = base.nextElement();
//            //System.err.println("Base.nextElement = " + node);
//            thisStep = step.enumerate(node, context);
//            if (thisStep.hasMoreElements()) {
//                return thisStep.nextElement();
//                //NodeInfo n2 = thisStep.nextElement();
//                //System.err.println("Starting Step.nextElement() = " + n2);
//                //return n2;
//            }
//        }
//        
//        return null;
//        
//    }
//    
//    /**
//     * Determine if we can guarantee that the nodes are in document order. This is true if the
//     * start nodes are sorted peer nodes and the step is within the subtree rooted at each node.
//     * It is also true if the start is a singleton node and the axis is sorted.
//     */
//    
//    public boolean isSorted() {
//        byte axis = step.getAxis();
//        return Axis.isForwards[axis] && (
//                                         ( (thisStart instanceof SingletonExpression) ||
//                                          (base.isSorted() && base.isPeer() && Axis.isSubtreeAxis[axis]) ||
//                                          (base.isSorted() && (axis==Axis.ATTRIBUTE || axis==Axis.NAMESPACE))
//                                          ));
//    }
//    
//    /**
//     * Determine if the nodes are guaranteed to be in reverse document order. This is true if the
//     * base is singular (e.g. the root node or the current node) and the axis is a reverse axis
//     */
//    
//    public boolean isReverseSorted() {
//        return thisStart instanceof SingletonExpression && Axis.isReverse[step.getAxis()];
//    }
//    
//    /**
//     * Determine if the resulting nodes are peer nodes, that is, if no node is a descendant of any
//     * other. This is the case if the start nodes are peer nodes and the axis is a peer axis.
//     */
//    
//    public boolean isPeer() {
//        return (base.isPeer() && Axis.isPeerAxis[step.getAxis()]);
//    }
//    
//}   // end of inner class PathEnumeration

@end
