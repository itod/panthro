//
//  XPFilterExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPFilterExpression.h"
#import "XPEmptyNodeSet.h"
#import "XPNumericValue.h"
#import "XPFilterEnumeration.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFilterExpression ()
@end

@implementation XPFilterExpression

/**
 * Constructor
 * @param start A node-set expression denoting the absolute or relative set of nodes from which the
 * navigation path should start.
 * @param filter An expression defining the filter predicate
 */

- (instancetype)initWithStart:(XPExpression *)start filter:(XPExpression *)filter {
    NSParameterAssert(start);
    NSParameterAssert(filter);
    self = [super init];
    if (self) {
        self.start = start;
        self.filter = filter;
    }
    return self;
}

- (void)dealloc {
    self.start = nil;
    self.filter = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"(%@)[%@]", _start, _filter];
}


/**
 * Simplify an expression
 */

- (XPExpression *)simplify {
    
    self.start = [_start simplify];
    self.filter = [_filter simplify];
    
    // ignore the filter if the base expression is an empty node-set
    if ([_start isKindOfClass:[XPEmptyNodeSet class]]) {
        return _start;
    }
    
    // check whether the filter is a constant true() or false()
    if ([_filter isValue] && ![_filter isKindOfClass:[XPNumericValue class]]) {
        BOOL f = [(XPValue *)_filter asBoolean];
        if (f) {
            return _start;
        } else {
            return [XPEmptyNodeSet emptyNodeSet];
        }
    }
    
//    // check whether the filter is [last()] (note, position()=last() will
//    // have already been simplified)
//    
//    if (filter instanceof Last) {
//        filter = new IsLastExpression(true);
//    }
//    
//    // following code is designed to catch the case where we recurse over a node-set
//    // setting $ns := $ns[position()>1]. The effect is to combine the accumulating
//    // filters, for example on the third iteration the filter will be effectively
//    // x[position()>3] rather than x[position()>1][position()>1][position()>1].
//    
//    if (start instanceof NodeSetIntent &&
//        filter instanceof PositionRange) {
//        PositionRange pred = (PositionRange)filter;
//        if (pred.getMinPosition()==2 && pred.getMaxPosition()==Integer.MAX_VALUE) {
//            //System.err.println("Found candidate ");
//            NodeSetIntent b = (NodeSetIntent)start;
//            //System.err.println("Found candidate start is " + b.getNodeSetExpression().getClass());
//            if (b.getNodeSetExpression() instanceof FilterExpression) {
//                FilterExpression t = (FilterExpression)b.getNodeSetExpression();
//                if (t.filter instanceof PositionRange) {
//                    PositionRange pred2 = (PositionRange)t.filter;
//                    if (pred2.getMaxPosition()==Integer.MAX_VALUE) {
//                        //System.err.println("Opt!! start =" + pred2.getMinPosition() );
//                        return new FilterExpression(t.start,
//                                                    new PositionRange(pred2.getMinPosition()+1, Integer.MAX_VALUE));
//                    }
//                }
//            }
//        }
//    }
    
    return self;
}

/**
 * Evaluate the filter expression in a given context to return a Node Enumeration
 * @param context the evaluation context
 * @param sort true if the result must be in document order
 */

- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sort {
    
    // if the expression references variables, or depends on other aspects
    // of the XSLT context, then fix up these dependencies now. If the expression
    // will only return nodes from the context document, then any dependency on
    // the context document within the predicate can also be fixed up now.
    
    XPDependencies actualdep = [self dependencies];
    XPDependencies removedep = 0;
    
    if ((actualdep & XPDependenciesXSLTContext) != 0) {
        removedep |= XPDependenciesXSLTContext;
    }
    
    if ([_start isContextDocumentNodeSet] && ((actualdep & XPDependenciesContextDocument) != 0)) {
        removedep |= XPDependenciesContextDocument;
    }
    
    if (removedep != 0) {
        return [[self reduceDependencies:removedep inContext:ctx] enumerateInContext:ctx sorted:sort];
    }
    
    if (!sort) {
        // the user didn't ask for document order, but we may need to do it anyway
        if (_filter.dataType==XPDataTypeNumber ||
            _filter.dataType==XPDataTypeAny ||
            ([_filter dependencies] & (XPDependenciesContextPosition|XPDependenciesLast)) != 0 ) {
            sort = YES;
        }
    }
    
//    if (start instanceof SingletonNodeSet) {
//        if (!((SingletonNodeSet)start).isGeneralUseAllowed()) {
//            throw new XPathException("To use a result tree fragment in a filter expression, either use exsl:node-set() or specify version='1.1'");
//        }
//    }
    
    id <XPNodeEnumeration>base = [_start enumerateInContext:ctx sorted:sort];
    if (![base hasMoreObjects]) {
        return base;        // quick exit for an empty node set
    }
    
    return [[[XPFilterEnumeration alloc] initWithBase:base filter:_filter context:ctx finishAfterReject:NO] autorelease];
}

/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    // not all dependencies in the filter expression matter, because the context node,
    // position, and size are not dependent on the outer context.
    if (_dependencies==NSNotFound) {
        _dependencies = [_start dependencies] | ([_filter dependencies] & XPDependenciesXSLTContext);
    }
    // System.err.println("Filter expression getDependencies() = " + dependencies);
    return _dependencies;
}

/**
 * Perform a partial evaluation of the expression, by eliminating specified dependencies
 * on the context.
 * @param dep The dependencies to be removed
 * @param context The context to be used for the partial evaluation
 * @return a new expression that does not have any of the specified
 * dependencies
 */

- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)context {
    if ((dep & [self dependencies]) != 0) {
        XPExpression *newstart = [_start reduceDependencies:dep inContext:context];
        XPExpression *newfilter = [_filter reduceDependencies:(dep & XPDependenciesXSLTContext) inContext:context];
        XPExpression *e = [[[XPFilterExpression alloc] initWithStart:newstart filter:newfilter] autorelease];
        e.staticContext = self.staticContext;
        return [e simplify];
    } else {
        return self;
    }
}

/**
 * Determine, in the case of an expression whose data type is Value.NODESET,
 * whether all the nodes in the node-set are guaranteed to come from the same
 * document as the context node. Used for optimization.
 */

- (BOOL)isContextDocumentNodeSet {
    return [_start isContextDocumentNodeSet];
}

@end
