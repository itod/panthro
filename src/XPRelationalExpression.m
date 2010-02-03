//
//  XPRelationalExpression.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPRelationalExpression.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPBooleanValue.h>

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@end

@implementation XPRelationalExpression

+ (id)relationalExpression {
    return [[[self alloc] init] autorelease];
}


+ (id)relationalExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    self.p1 = [p1 simplify];
    self.p2 = [p2 simplify];
    
    // TODO
    
    if ([p1 isValue] && [p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    // TODO
    return self;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    return [XPBooleanValue booleanValueWithBoolean:b];
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    XPValue *s1 = [p1 evaluateInContext:ctx];
    XPValue *s2 = [p2 evaluateInContext:ctx];
    
    return [s1 compareToValue:s2 usingOperator:operator];
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}

@end
