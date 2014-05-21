//
//  XPVariableReference.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import "XPVariableReference.h"
#import "XPContext.h"
//#import "XPBindery.h"
//#import "XPBinding.h"

@interface XPVariableReference ()
//@property (nonatomic, retain, readwrite) id <XPBinding>binding;
@end

@implementation XPVariableReference

/**
 * Constructor
 * @param name the variable name (as a Name object)
 */

//- (instancetype)initWithName:(NSString *)name staticContext:(id <XPStaticContext>)env {
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
//        self.binding = [staticContext bindVariable:name];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
//    self.binding = nil;
    [super dealloc];
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

    if ((dep & XPDependenciesVariables) != 0) {
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
    
//    id <XPBindery>b = [c bindery];
//    XPValue *v = [b value:_binding];
//    
//    if (!v) {
//        
//        if (![_binding isGlobal]) {
//            [NSException raise:@"XPathException" format:@"Variable %@ is undefined", [_binding variableName]];
//        }
//        
//        // it must be a forwards reference; try to evaluate it now.
//        // but first set a flag to stop looping. This flag is set in the Bindery because
//        // the VariableReference itself can be used by multiple threads simultaneously
//        
//        @try {
//            
//            b.setExecuting(binding, true);
//            
//            if (binding instanceof XSLGeneralVariable) {
//                if (c.getController().isTracing()) { // e.g.
//                    TraceListener listener = c.getController().getTraceListener();
//                    
//                    listener.enter((XSLGeneralVariable)binding, c);
//                    ((XSLGeneralVariable)binding).process(c);
//                    listener.leave((XSLGeneralVariable)binding, c);
//                    
//                } else {
//                    ((XSLGeneralVariable)binding).process(c);
//                }
//            }
//            
//            b.setExecuting(binding, false);
//            
//            v = b.getValue(binding);
//            
//        } catch (TransformerException err) {
//            if (err instanceof XPathException) {
//                throw (XPathException)err;
//            } else {
//                throw new XPathException(err);
//            }
//        }
//        
//        if (!v) {
//            [NSException raise:@"XPathException" format:@"Variable %@ is undefined", [_binding variableName]];
//        }
//    }
    
    XPValue *v = [ctx.staticContext valueForVariable:self.name];
    v.range = self.range;
    return v;
}


/**
 * Determine the data type of the expression, if possible
 * @return the type of the variable, if this can be determined statically;
 * otherwise Value.ANY (meaning not known in advance)
 */

- (XPDataType)dataType {
//    return [_binding dataType];
    return XPDataTypeAny;
}


/**
 * Simplify the expression. If the variable has a fixed value, the variable reference
 * will be replaced with that value.
 */

- (XPExpression *)simplify {
//    XPValue *v = [_binding constantValue];
//    if (!v) {
//        return self;
//    } else {
//        return v;
//    }
    return self;
}

@end
