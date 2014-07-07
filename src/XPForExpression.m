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
#import "XPLetClause.h"
#import "XPNumericValue.h"

@interface XPForExpression ()
@property (nonatomic, retain) NSArray *forClauses;
@property (nonatomic, retain) XPExpression *whereExpression;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, retain) NSMutableArray *result;
@end

@implementation XPForExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses where:(XPExpression *)whereExpr body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.forClauses = forClauses;
        self.whereExpression = whereExpr;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.forClauses = nil;
    self.whereExpression = nil;
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
    
    XPForClause *curForClause = forClauses[0];
    NSArray *forClausesTail = [forClauses subarrayWithRange:NSMakeRange(1, [forClauses count]-1)];
    
    id <XPSequenceEnumeration>seqEnm = [curForClause.expression enumerateInContext:ctx sorted:NO];

    NSUInteger idx = 1;
    while ([seqEnm hasMoreItems]) {
        id <XPItem>inItem = [seqEnm nextItem];
        [ctx setItem:inItem forVariable:curForClause.variableName];
        if (curForClause.positionName) {
            [ctx setItem:[XPNumericValue numericValueWithNumber:idx++] forVariable:curForClause.positionName];
        }

        if ([forClausesTail count]) {
            [self loopInContext:ctx forClauses:forClausesTail];
        } else {
            
            for (XPLetClause *letClause in curForClause.letClauses) {
                id <XPItem>letItem = [letClause.expression evaluateInContext:ctx];
                [ctx setItem:letItem forVariable:letClause.variableName];
            }
            
            BOOL whereTest = YES;
            if (_whereExpression) {
                whereTest = [_whereExpression evaluateAsBooleanInContext:ctx];
            }
            
            if (whereTest) {
                id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
                while ([bodyEnm hasMoreItems]) {
                    id <XPItem>bodyItem = [bodyEnm nextItem];
                    [_result addObject:bodyItem];
                }
            }
        }
        
        // remove let vars
        for (XPLetClause *letClause in curForClause.letClauses) {
            [ctx setItem:nil forVariable:letClause.variableName];
        }
        // remove at var
        if (curForClause.positionName) {
            [ctx setItem:nil forVariable:curForClause.positionName];
        }

        // remove for var
        [ctx setItem:nil forVariable:curForClause.variableName];
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
