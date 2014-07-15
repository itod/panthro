//
//  XPSequenceExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSequenceExpression.h"
#import "XPSequenceExtent.h"
#import "XPSequenceEnumeration.h"

@implementation XPSequenceExpression

+ (instancetype)sequenceExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsSequenceInContext:ctx];
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    NSMutableArray *v = [NSMutableArray array];
    
    if ([self.p1 dataType] == XPDataTypeSequence || [self.p1 dataType] == XPDataTypeAny) {
        id <XPSequenceEnumeration>enm = [(XPSequenceValue *)self.p1 enumerateInContext:ctx sorted:NO];
        while ([enm hasMoreItems]) {
            [v addObject:[enm nextItem]];
        }
    } else {
        [v addObject:[self.p1 evaluateInContext:ctx]];
    }

    if ([self.p2 dataType] == XPDataTypeSequence || [self.p2 dataType] == XPDataTypeAny) {
        id <XPSequenceEnumeration>enm = [(XPSequenceValue *)self.p2 enumerateInContext:ctx sorted:NO];
        while ([enm hasMoreItems]) {
            [v addObject:[enm nextItem]];
        }
    } else {
        [v addObject:[self.p2 evaluateInContext:ctx]];
    }
    
    XPSequenceValue *seq = [[[XPSequenceExtent alloc] initWithContent:v] autorelease];
    return seq;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
