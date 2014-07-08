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
#import "XPOrderClause.h"
#import "XPTuple.h"
#import "XPOrderSpec.h"
#import "XPEGParser.h"
#import "XPNumericValue.h"

@interface XPForExpression ()
@property (nonatomic, retain) NSArray *forClauses;
@property (nonatomic, retain) XPExpression *whereExpression;
@property (nonatomic, retain) NSArray *orderClauses;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, retain) NSMutableArray *tuples;
@end

@implementation XPForExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses where:(XPExpression *)whereExpr orderClauses:(NSArray *)orderClauses body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.forClauses = forClauses;
        self.whereExpression = whereExpr;
        self.orderClauses = orderClauses;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.forClauses = nil;
    self.whereExpression = nil;
    self.orderClauses = nil;
    self.bodyExpression = nil;
    self.tuples = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsNodeSetInContext:ctx];
}


- (XPSequenceValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    XPAssert([_forClauses count]);
    XPAssert(_bodyExpression);
    
    self.tuples = [NSMutableArray array];

    [self loopInContext:ctx forClauses:_forClauses];
    
    // order by
    NSUInteger orderClauseCount = [_orderClauses count];
    if (orderClauseCount > 0) {
        [_tuples sortUsingComparator:^NSComparisonResult(XPTuple *t1, XPTuple *t2) {
            NSComparisonResult res = NSOrderedSame;
            NSUInteger orderSpecIdx = 0;

            do {
                XPOrderSpec *spec1 = t1.orderSpecs[orderSpecIdx];
                XPOrderSpec *spec2 = t2.orderSpecs[orderSpecIdx];
                XPAssert(spec1.modifier == spec2.modifier);
                
                XPValue *val1 = spec1.value;
                XPValue *val2 = spec2.value;
                
                NSComparisonResult mod = spec1.modifier;
                XPAssert(NSOrderedSame != mod);
                
                if ([val1 isKindOfClass:[XPValue class]] && [val2 isKindOfClass:[XPValue class]]) {
                    if ([val1 isStringValue] && [val2 isStringValue]) {
                        if (NSOrderedAscending == mod) {
                            res = [[val1 stringValue] compare:[val2 stringValue]];
                        } else {
                            res = [[val2 stringValue] compare:[val1 stringValue]];
                        }
                    } else {
                        BOOL isLT = [val1 compareToValue:val2 usingOperator:XPEG_TOKEN_KIND_LT_SYM];
                        if (NSOrderedAscending == mod) {
                            res = isLT ? NSOrderedAscending : NSOrderedDescending;
                        } else {
                            res = isLT ? NSOrderedDescending : NSOrderedAscending;
                        }
                    }
                }
                
                ++orderSpecIdx;
            } while (NSOrderedSame == res && orderSpecIdx < orderClauseCount);
                
            return res;
        }];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (XPTuple *t in _tuples) {
        for (id <XPItem>item in t.resultItems) {
            // YIKES. This is for XPSingletonNodeSet-wrapped NodeInfos
            if (![item isAtomic]) {
                item = [item head];
            }
            [result addObject:item];
        }
    }
    
    XPSequenceValue *seq = [[[XPSequenceExtent alloc] initWithContent:result] autorelease];
    self.tuples = nil;
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

        for (XPLetClause *letClause in curForClause.letClauses) {
            id <XPItem>letItem = [letClause.expression evaluateInContext:ctx];
            [ctx setItem:letItem forVariable:letClause.variableName];
        }
        
        if ([forClausesTail count]) {
            [self loopInContext:[[ctx copy] autorelease] forClauses:forClausesTail];
        } else {
            
            // where test
            BOOL whereTest = YES;
            if (_whereExpression) {
                whereTest = [_whereExpression evaluateAsBooleanInContext:ctx];
            }
            
            if (whereTest) {
                id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
                
                NSMutableArray *tupleResItems = [NSMutableArray array];
                NSMutableArray *tupleOrderSpecs = [NSMutableArray array];
                
                while ([bodyEnm hasMoreItems]) {
                    id <XPItem>bodyItem = [bodyEnm nextItem];
                    
                    [tupleResItems addObject:bodyItem];
                    
                    for (XPOrderClause *orderClause in _orderClauses) {
                        XPValue *specVal = XPAtomize([orderClause.expression evaluateInContext:ctx]);
                        XPOrderSpec *spec = [XPOrderSpec orderSpecWithValue:specVal modifier:orderClause.modifier];
                        [tupleOrderSpecs addObject:spec];
                    }
                }

                XPTuple *t = [XPTuple tupeWithResultItems:tupleResItems orderSpecs:tupleOrderSpecs];
                [_tuples addObject:t];
            }
        }
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
