//
//  XPSimpleMapExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSimpleMapExpression.h"
#import "XPValue.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceExtent.h"
#import "XPEmptySequence.h"
#import "XPContext.h"

@implementation XPSimpleMapExpression

+ (XPSimpleMapExpression *)simpleMapExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];

    if ([self.p1 isValue] && [self.p2 isValue]) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
    val.range = self.range;
    return val;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = [XPEmptySequence instance];
    
    XPSequenceValue *seq1 = [self.p1 evaluateAsSequenceInContext:ctx];
    id <XPSequenceEnumeration>enm1 = [seq1 enumerateInContext:ctx sorted:NO];
    
    ctx = [[ctx copy] autorelease];
    NSMutableArray *content = [NSMutableArray array];
    
    while ([enm1 hasMoreItems]) {
        id <XPItem>item1 = [enm1 nextItem];
        ctx.contextNode = (id)item1;
        
        XPValue *seq2 = [self.p2 evaluateAsSequenceInContext:ctx];
        if ([seq2 isAtomic]) {
            [content addObject:seq2];
        } else {
            id <XPSequenceEnumeration>enm2 = [seq2 enumerateInContext:ctx sorted:NO];
            
            while ([enm2 hasMoreItems]) {
                id <XPItem>item2 = [enm2 nextItem];
                [content addObject:item2];
            }
        }
    }
    
    if ([content count]) {
        result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
    }
    
    return result;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
