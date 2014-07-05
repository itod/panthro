//
//  XPSequenceExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSequenceExpression.h"
#import "XPAtomicSequence.h"
#import "XPSequenceEnumeration.h"

@implementation XPSequenceExpression

+ (instancetype)sequenceExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSMutableArray *v = [NSMutableArray array];
    
    if ([self.p1 isValue] && [(XPValue *)self.p1 isSequenceValue]) {
        id <XPSequenceEnumeration>enm = [(XPSequenceValue *)self.p1 enumerateInContext:ctx sorted:NO];
        while ([enm hasMoreItems]) {
            [v addObject:[enm nextItem]];
        }
    } else {
        [v addObject:self.p1];
    }

    [v addObject:self.p2];
    
    XPValue *seq = [[[XPAtomicSequence alloc] initWithContent:v] autorelease];
    return seq;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
