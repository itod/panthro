//
//  XPFunctionReference.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import "XPFunctionCall.h"
#import "XPContext.h"
#import "XPUserFunction.h"
#import "XPException.h"

@interface XPFunctionCall ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation XPFunctionCall

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (instancetype)initWithExpression:(XPExpression *)expr {
    self = [super init];
    if (self) {
        self.expression = expr;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.expression = nil;
    self.args = nil;
    [super dealloc];
}


- (NSString *)description {
    NSString *name = _name ? _name : [_expression description];
    NSMutableString *s = [NSMutableString stringWithFormat:@"%@(", name];
    
    NSUInteger i = 0;
    NSUInteger c = [self numberOfArguments];
    for (NSString *arg in _args) {
        NSString *fmt = i++ == c - 1 ? @"%@" : @"%@, ";
        [s appendFormat:fmt, arg];
    }
    [s appendString:@")"];
    return s;
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


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSParameterAssert(ctx);
    XPAssert([_name length] || _expression);
    
    XPUserFunction *fn = nil;
    
    if (_name) {
        fn = [ctx.staticContext userFunctionNamed:_name];
    } else {
        XPAssert(_expression);
        fn = (id)[_expression evaluateInContext:ctx];
    }
    
    if (!fn || ![fn isKindOfClass:[XPUserFunction class]]) {
        [XPException raiseIn:self format:@"Call to unknown function: %@()", _name];
    }
    
    NSUInteger numArgs = [self numberOfArguments];
    NSUInteger numParams = [fn numberOfParameters];
    
    for (NSUInteger i = 0; i < numParams; ++i) {
        if (i >= numArgs) break;
        
        NSString *paramName = [fn parameterAtIndex:i];
        XPValue *val = [_args[i] evaluateInContext:ctx];
        [fn setItem:val forVariable:paramName];
    }
    
    XPValue *result = [fn callInContext:ctx];
    
    XPAssert(result);
    return result;
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}


- (XPExpression *)simplify {
    return self;
}


#pragma mark -
#pragma mark Arguments

- (void)addArgument:(XPExpression *)expr {
    NSParameterAssert(expr);
    
    if (!_args) {
        self.args = [NSMutableArray arrayWithCapacity:6];
    }
    
    [_args addObject:expr];
}


- (NSUInteger)numberOfArguments {
    return [_args count];
}

@end
