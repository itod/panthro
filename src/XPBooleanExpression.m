//
//  XPBooleanExpression.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPBooleanExpression.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPBooleanValue.h>

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@end

@implementation XPBooleanExpression

+ (id)booleanExpression {
    return [[[self alloc] init] autorelease];
}


+ (id)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    self.p1 = [p1 simplify];
    self.p2 = [p2 simplify];
    if ([p2 isValue] && [p2 isValue]) {
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
    BOOL b1 = [p1 evaluateAsBooleanInContext:ctx];
    BOOL b2 = [p2 evaluateAsBooleanInContext:ctx];
    
    BOOL result = NO;
    switch (operator) {
        case XPTokenTypeAnd:
            result = b1 && b2;
            break;
        case XPTokenTypeOr:
            result = b1 || b2;
            break;
        default:
            NSAssert(0, @"should not reach here");
            break;
    }

    return result;
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}

@end
