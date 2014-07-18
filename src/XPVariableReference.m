//
//  XPVariableReference.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import "XPVariableReference.h"
#import "XPContext.h"
#import "XPException.h"
#import "XPSingletonNodeSet.h"
#import "XPNodeInfo.h"

@interface XPVariableReference ()
@end

@implementation XPVariableReference

/**
 * Constructor
 * @param name the variable name (as a Name object)
 */

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPVariableReference *expr = [super copyWithZone:zone];
    expr.name = _name;
    return expr;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"$%@", self.name];
}


/**
 * Determine which aspects of the context the expression depends on. The result is
 * a bitwise-or'ed value composed from constants such as XPDependenciesVariables and
 * Context.CURRENT_NODE
 */

- (XPDependencies)dependencies {
    return XPDependenciesVariables;
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
        result = [self evaluateInContext:ctx];
        result.range = self.range;
    }
    
    return result;
}


/**
 * Get the value of this variable in a given context.
 * @param context the Context which contains the relevant variable bindings
 * @return the value of the variable, if it is defined
 * @throw XPathException if the variable is undefined
 */

- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPAssert(ctx);
    
    XPValue *val = nil;
    id <XPItem>item = [ctx.currentScope itemForVariable:self.name];
    
    if ([item isKindOfClass:[XPValue class]]) {
        val = (id)item;
    } else if (item) {
        XPAssert([item conformsToProtocol:@protocol(XPNodeInfo)]);
        val = [XPSingletonNodeSet singletonNodeSetWithNode:(id <XPNodeInfo>)item];
    } else {
        [XPException raiseIn:self format:@"Variable `$%@` has not been declared (or its declaration is not in scope)", self.name];
    }

    val.range = self.range;
    return val;
}


/**
 * Determine the data type of the expression, if possible
 * @return the type of the variable, if this can be determined statically;
 * otherwise Value.ANY (meaning not known in advance)
 */

- (XPDataType)dataType {
    return XPDataTypeAny;
}


/**
 * Simplify the expression. If the variable has a fixed value, the variable reference
 * will be replaced with that value.
 */

- (XPExpression *)simplify {
    return self;
}

@end
