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


//- (XPExpression *)simplify {
//    XPExpression *result = self;
//    
//    self.p1 = [self.p1 simplify];
//    self.p2 = [self.p2 simplify];
//    
//    if ([self.p1 isValue] && [(XPValue *)self.p1 isSequenceValue]) {
//        
//    }
//    
//    else if ([self.p1 isValue] && [self.p2 isValue]) {
//        result = [self evaluateInContext:nil];
//    }
//    
//    result.range = self.range;
//    return result;
//}


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


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    XPAssert(0);
    return 0.0;
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}

@end
