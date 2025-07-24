//
//  XPIsExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeComparisonExpression.h"
#import <Panthro/XPValue.h>
#import "XPSequenceEnumeration.h"
#import "XPEmptySequence.h"
#import "XPException.h"
#import "XPBooleanValue.h"
#import "XPNodeInfo.h"
#import "XPEGParser.h"

@implementation XPNodeComparisonExpression

+ (instancetype)isExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@", self.p1, self.operatorString, self.p2];
}


- (NSString *)operatorString {
    NSString *opStr = nil;
    switch (self.operator) {
        case XPEG_TOKEN_KIND_IS:
            opStr = @"is";
            break;
        case XPEG_TOKEN_KIND_SHIFT_LEFT:
            opStr = @"<<";
            break;
        case XPEG_TOKEN_KIND_SHIFT_RIGHT:
            opStr = @">>";
            break;
        default:
            XPAssert(0);
            break;
    }
    return opStr;
}


- (void)raiseWithLhs:(XPValue *)lhs rhs:(XPValue *)rhs {
    [XPException raiseIn:self format:@"`%@` node comparision requires comparision of two sequences of exactly 0 or 1 nodes. Given: %@ %@ %@", lhs, self.operatorString, rhs];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    
    XPValue *lhs = [self.p1 evaluateInContext:ctx];
    if (lhs == [XPEmptySequence instance]) {
        return lhs;
    }

    XPValue *rhs = [self.p2 evaluateInContext:ctx];
    if (rhs == [XPEmptySequence instance]) {
        return rhs;
    }
    
    id <XPSequenceEnumeration>enm1 = [lhs enumerate];
    if (![enm1 hasMoreItems]) {
        [self raiseWithLhs:lhs rhs:rhs];
    }
    id <XPNodeInfo>node1 = [enm1 nextNodeInfo];
    if ([enm1 hasMoreItems]) {
        [self raiseWithLhs:lhs rhs:rhs];
    }
    
    id <XPSequenceEnumeration>enm2 = [rhs enumerate];
    if (![enm2 hasMoreItems]) {
        [self raiseWithLhs:lhs rhs:rhs];
    }
    id <XPNodeInfo>node2 = [enm2 nextNodeInfo];
    if ([enm2 hasMoreItems]) {
        [self raiseWithLhs:lhs rhs:rhs];
    }
    
    BOOL res = NO;
    
    switch (self.operator) {
        case XPEG_TOKEN_KIND_IS:
            res = [node1 isSameNodeInfo:node2];
            break;
        case XPEG_TOKEN_KIND_SHIFT_LEFT:
            res = ([node1 compareOrderTo:node2] < 0);
            break;
        case XPEG_TOKEN_KIND_SHIFT_RIGHT:
            res = ([node1 compareOrderTo:node2] > 0);
            break;
        default:
            XPAssert(0);
            break;
    }
    
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}

@end
