//
//  XPBinaryExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"
#import "XPValue.h"

@implementation XPBinaryExpression

- (instancetype)init {
    NSAssert1(0, @"call -[%@ initWithOperand:operator:operand:] instead", [self class]);
    return nil;
}


- (instancetype)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    if (self = [super init]) {
        self.p1 = lhs;
        self.p2 = rhs;
        self.operator = op;
    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPBinaryExpression *expr = [super copyWithZone:zone];
    expr.p1 = [[_p1 copy] autorelease];
    expr.p2 = [[_p2 copy] autorelease];
    expr.operator = _operator;
    return expr;
}


- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    self.p1 = lhs;
    self.p2 = rhs;
    self.operator = op;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [_p1 simplify];
    self.p2 = [_p2 simplify];
    
    if ([_p1 isValue] && [_p2 isValue]) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPDependencies)dependencies {
    return [_p1 dependencies] | [_p2 dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;
    
    if ((self.dependencies & dep) != 0) {
        result = [[[[self class] alloc] initWithOperand:[_p1 reduceDependencies:dep inContext:ctx]
                                               operator:_operator
                                                operand:[_p2 reduceDependencies:dep inContext:ctx]] autorelease];
        result.staticContext = self.staticContext;
        result.range = self.range;
        result = [result simplify];
    }
    
    return result;
}

@end
