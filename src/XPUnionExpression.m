//
//  XPUnionExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPUnionExpression.h"
#import "XPEmptyNodeSet.h"
#import "XPUnionEnumeration.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"

@interface XPUnionExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@end

@implementation XPUnionExpression

/**
 * Constructor
 * @param p1 the left-hand operand
 * @param p2 the right-hand operand
 */

- (instancetype)initWithLhs:(XPExpression *)lhs rhs:(XPExpression *)rhs {
    XPAssert(lhs);
    XPAssert(rhs);
    self = [super init];
    if (self) {
        self.p1 = lhs;
        self.p2 = rhs;
    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@>", _p1, [self operator], _p2];
}


- (NSString *)operator {
    return @"union";
}


- (Class)enumerationClass {
    return [XPUnionEnumeration class];
}


/**
 * Simplify an expression
 * @return the simplified expression
 */

- (XPExpression *)simplify {
    XPExpression *result = self;
    self.p1 = [_p1 simplify];
    self.p2 = [_p2 simplify];
    if ([_p1 isKindOfClass:[XPEmptyNodeSet class]]) {
        result = _p2;
    } else if ([_p2 isKindOfClass:[XPEmptyNodeSet class]]) {
        result = _p1;
    }
    result.range = self.range;
    return result;
}


/**
 * Evaluate the union expression. The result will always be sorted in document order,
 * with duplicates eliminated
 * @param c The context for evaluation
 * @param sort Request the nodes in document order (they will be, regardless)
 * @return a NodeSetValue representing the union of the two operands
 */

- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sort {
    Class cls = [self enumerationClass];
    
    id <XPSequenceEnumeration>enm1 = [_p1 enumerateInContext:ctx sorted:YES];
    id <XPSequenceEnumeration>enm2 = [_p2 enumerateInContext:ctx sorted:YES];
    
//    if (![enm1 isKindOfClass:[XPAbstractNodeEnumeration class]] || ![enm2 isKindOfClass:[XPAbstractNodeEnumeration class]]) {
//        [XPException raiseIn:self format:@"The %@ operator accepts only node-set arguments", self.operator];
//    }
    
    return [[[cls alloc] initWithLhs:enm1 rhs:enm2 comparer:[XPLocalOrderComparer instance]] autorelease];
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as Context.VARIABLES and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    return _p1.dependencies | _p2.dependencies;
}


/**
 * Determine, in the case of an expression whose data type is Value.NODESET,
 * whether all the nodes in the node-set are guaranteed to come from the same
 * document as the context node. Used for optimization.
 */

- (BOOL)isContextDocumentNodeSet {
    return [_p1 isContextDocumentNodeSet] && [_p2 isContextDocumentNodeSet];
}


/**
 * Perform a partial evaluation of the expression, by eliminating specified dependencies
 * on the context.
 * @param dependencies The dependencies to be removed
 * @param context The context to be used for the partial evaluation
 * @return a new expression that does not have any of the specified
 * dependencies
 */

- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;

    if ((self.dependencies & dep) != 0) {
        XPExpression *e = [[[[self class] alloc] initWithLhs:[_p1 reduceDependencies:dep inContext:ctx]
                                                         rhs:[_p2 reduceDependencies:dep inContext:ctx]] autorelease];
        e.staticContext = self.staticContext;
        e.range = self.range;
        result = e;
    }
    
    return result;
}

@end
