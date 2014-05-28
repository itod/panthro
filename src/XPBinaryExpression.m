//
//  XPBinaryExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"
#import "XPValue.h"

@interface XPExpression ()
@property (nonatomic, retain, readwrite) id <XPStaticContext>staticContext;
@end

@implementation XPBinaryExpression

+ (XPBinaryExpression *)binaryExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBinaryExpression *)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (instancetype)init {
    return [self initWithOperand:nil operator:-1 operand:nil];
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
