//
//  XPPositionRange.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPPositionRange.h"
#import "XPBooleanValue.h"
#import "XPContext.h"

@implementation XPPositionRange

- (instancetype)initWithMin:(NSUInteger)min max:(NSUInteger)max {
    self = [super init];
    if (self) {
        self.minPosition = min;
        self.maxPosition = max;
    }
    return self;
}

    /**
     * Simplify an expression
     * @return the simplified expression
     */
    
- (XPExpression *)simplify {
    return self;
}
    
    /**
     * Evaluate the expression in a given context
     * @param c the given context for evaluation
     * @return a BooleanValue representing the result of the numeric comparison of the two operands
     */
    
- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPBooleanValue booleanValueWithBoolean:[self evaluateAsBooleanInContext:ctx]];
}


    /**
     * Evaluate the expression in a given context
     * @param c the given context for evaluation
     * @return a boolean representing the result of the numeric comparison of the two operands
     */
    
- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    int p = [ctx contextPosition];
    return p >= _minPosition && p <= _maxPosition;
}

    /**
     * Determine the data type of the expression
     * @return Value.BOOLEAN
     */

- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

    /**
     * Get the dependencies
     */
    
- (XPDependencies)dependencies {
    return XPDependenciesContextPosition;
}


    /**
     * Perform a partial evaluation of the expression, by eliminating specified dependencies
     * on the context.
     * @param dependencies The dependencies to be removed
     * @param context The context to be used for the partial evaluation
     * @return a new expression that does not have any of the specified
     * dependencies
     */
    
- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if ((XPDependenciesContextPosition & self.dependencies) != 0) {
        return [self evaluateInContext:ctx];
    }
    return self;
}

@end
