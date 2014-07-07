//
//  XPForExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPForExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceExtent.h"
#import "XPForClause.h"

@interface XPForExpression ()
@property (nonatomic, retain) NSArray *forClauses;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, retain) NSMutableArray *result;
@end

@implementation XPForExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.forClauses = forClauses;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.forClauses = nil;
    self.bodyExpression = nil;
    self.result = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsNodeSetInContext:ctx];
}


- (XPSequenceValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    XPAssert([_forClauses count]);
    XPAssert(_bodyExpression);
    
    self.result = [NSMutableArray array];

    [self loopInContext:ctx forClauses:_forClauses];
    
    XPSequenceValue *seq = [[[XPSequenceExtent alloc] initWithContent:_result] autorelease];
    self.result = nil;
    return seq;
}


- (void)loopInContext:(XPContext *)ctx forClauses:(NSArray *)forClauses {
    XPAssert([forClauses count]);
    XPAssert(_bodyExpression);
    
    XPForClause *curClause = forClauses[0];
    NSArray *forClausesTail = [forClauses subarrayWithRange:NSMakeRange(1, [forClauses count]-1)];
    
    id <XPSequenceEnumeration>seqEnm = [curClause.sequenceExpression enumerateInContext:ctx sorted:NO];

    while ([seqEnm hasMoreItems]) {
        id <XPItem>inItem = [seqEnm nextItem];
        [ctx setItem:inItem forVariable:curClause.variableName];

        if ([forClausesTail count]) {
            [self loopInContext:ctx forClauses:forClausesTail];
        } else {
            id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
            while ([bodyEnm hasMoreItems]) {
                id <XPItem>bodyItem = [bodyEnm nextItem];
                [_result addObject:bodyItem];
            }
        }

        [ctx setItem:nil forVariable:curClause.variableName];
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
