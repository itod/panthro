//
//  XPBooleanExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPBooleanExpression.h>
#import <XPath/XPValue.h>
#import <XPath/XPBooleanValue.h>

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation XPBooleanExpression

+ (XPBooleanExpression *)booleanExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBooleanExpression *)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    if ([self.p2 isValue] && [self.p2 isValue]) {
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
    BOOL b1 = [self.p1 evaluateAsBooleanInContext:ctx];
    BOOL b2 = [self.p2 evaluateAsBooleanInContext:ctx];
    
    BOOL result = NO;
    switch (self.operator) {
        case XPTokenTypeAnd:
            result = b1 && b2;
            break;
        case XPTokenTypeOr:
            result = b1 || b2;
            break;
        default:
            XPAssert(0);
            break;
    }

    return result;
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}

@end
