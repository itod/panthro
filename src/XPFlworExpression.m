//
//  XPForExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPFlworExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceExtent.h"
#import "XPForClause.h"
#import "XPLetClause.h"
#import "XPGroupClause.h"
#import "XPOrderClause.h"
#import "XPTuple.h"
#import "XPGroupSpec.h"
#import "XPOrderSpec.h"
#import "XPEGParser.h"
#import "XPNumericValue.h"

@interface XPFlworExpression ()
@property (nonatomic, retain) NSArray *forClauses;
@property (nonatomic, retain) XPExpression *whereExpression;
@property (nonatomic, retain) NSArray *groupClauses;
@property (nonatomic, retain) NSArray *orderClauses;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, retain) NSMutableArray *tuples;
@end

@implementation XPFlworExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses where:(XPExpression *)whereExpr groupClauses:(NSArray *)groupClauses orderClauses:(NSArray *)orderClauses body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.forClauses = forClauses;
        self.whereExpression = whereExpr;
        self.groupClauses = groupClauses;
        self.orderClauses = orderClauses;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.forClauses = nil;
    self.whereExpression = nil;
    self.groupClauses = nil;
    self.orderClauses = nil;
    self.bodyExpression = nil;
    self.tuples = nil;
    [super dealloc];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPForClause *forClause in _forClauses) {
        dep |= [forClause.expression dependencies];
    }
    
    dep |= [_whereExpression dependencies];

    for (XPOrderClause *orderClause in _orderClauses) {
        dep |= [orderClause.expression dependencies];
    }

    dep |= [_bodyExpression dependencies];

    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    return self; // TODO
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsSequenceInContext:ctx];
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
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
                
                XPAssert([val1 isKindOfClass:[XPValue class]]);
                XPAssert([val2 isKindOfClass:[XPValue class]]);
                
                NSComparisonResult mod = spec1.modifier;
                XPAssert(NSOrderedSame != mod);
                
                if (NSOrderedAscending == mod) {
                    res = [val1 compareToValue:val2];
                } else {
                    res = [val2 compareToValue:val1];
                }
                
                ++orderSpecIdx;
            } while (NSOrderedSame == res && orderSpecIdx < orderClauseCount);
                
            return res;
        }];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (XPTuple *t in _tuples) {
        [result addObjectsFromArray:t.resultItems];
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
        id <XPItem>forItem = [seqEnm nextItem];
        [ctx setItem:forItem forVariable:curForClause.variableName];
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
                NSMutableArray *tupleGroupSpecs = [NSMutableArray array];
                NSMutableArray *tupleOrderSpecs = [NSMutableArray array];
                
                while ([bodyEnm hasMoreItems]) {
                    // YIKES. This call to -head is for XPSingletonNodeSet-wrapped NodeInfos
                    id <XPItem>bodyItem = [[bodyEnm nextItem] head];
                    
                    [tupleResItems addObject:bodyItem];
                    
                    for (XPGroupClause *groupClause in _groupClauses) {
                        // calling -head here for force a single atomic value. but supposed to throw and exception if it's a sequence with more than 1 item
                        XPValue *specVal = [XPAtomize([groupClause.expression evaluateInContext:ctx]) head];
                        XPGroupSpec *spec = [XPGroupSpec groupSpecWithValue:specVal];
                        [tupleGroupSpecs addObject:spec];
                    }
                    
                    for (XPOrderClause *orderClause in _orderClauses) {
                        // calling -head here for force a single atomic value. but supposed to throw and exception if it's a sequence with more than 1 item
                        XPValue *specVal = [XPAtomize([orderClause.expression evaluateInContext:ctx]) head];
                        XPOrderSpec *spec = [XPOrderSpec orderSpecWithValue:specVal modifier:orderClause.modifier];
                        [tupleOrderSpecs addObject:spec];
                    }
                }

                XPTuple *t = [XPTuple tupeWithResultItems:tupleResItems groupSpecs:tupleGroupSpecs orderSpecs:tupleOrderSpecs];
                [_tuples addObject:t];
            }
        }
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
