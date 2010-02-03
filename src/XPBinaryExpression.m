//
//  XPBinaryExpression.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPBinaryExpression.h>
#import <Exedore/XPValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic) NSInteger operator;
@end

@implementation XPBinaryExpression

+ (id)binaryExpression {
    return [[[self alloc] init] autorelease];
}


+ (id)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (id)init {
    return [self initWithOperand:nil operator:-1 operand:nil];
}


- (id)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
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
    self.p1 = [p1 simplify];
    self.p2 = [p2 simplify];
    
    if ([p1 isValue] && [p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (NSUInteger)dependencies {
    return [p1 dependencies] | [p2 dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (([self dependencies] & dep) != 0) {
        XPExpression *expr = [[[[self class] alloc] initWithOperand:[p1 reduceDependencies:dep inContext:ctx]
                                                           operator:operator
                                                            operand:[p2 reduceDependencies:dep inContext:ctx]] autorelease];
        [expr setStaticContext:[self staticContext]];
        return [expr simplify];
    } else {
        return self;
    }
}

@synthesize p1;
@synthesize p2;
@synthesize operator;
@end
