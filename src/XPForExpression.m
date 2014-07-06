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

@interface XPForExpression ()
@property (nonatomic, retain) NSArray *varNames;
@property (nonatomic, retain) NSArray *sequences;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, retain) NSMutableArray *result;
@end

@implementation XPForExpression

- (instancetype)initWithVarNames:(NSArray *)varNames sequences:(NSArray *)sequences body:(XPExpression *)bodyExpr {
    XPAssert([varNames count] == [sequences count]);
    self = [super init];
    if (self) {
        self.varNames = varNames;
        self.sequences = sequences;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.varNames = nil;
    self.sequences = nil;
    self.bodyExpression = nil;
    self.result = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPAssert([_varNames count]);
    XPAssert([_sequences count]);
    XPAssert([_varNames count] == [_sequences count]);
    XPAssert(_bodyExpression);
    
    self.result = [NSMutableArray array];

    [self loopInContext:ctx varNames:_varNames sequences:_sequences];
    
    XPValue *seq = [[[XPSequenceExtent alloc] initWithContent:[[_result copy] autorelease]] autorelease];

    self.result = nil;
    return seq;
}


- (void)loopInContext:(XPContext *)ctx varNames:(NSArray *)varNames sequences:(NSArray *)sequences {
    XPAssert([varNames count] == [sequences count]);
    XPAssert(_bodyExpression);

    if (![varNames count]) return;
    
    NSString *varName = varNames[0];
    NSArray *varNameTail = [varNames subarrayWithRange:NSMakeRange(1, [varNames count]-1)];
    
    XPExpression *seqExpr = sequences[0];
    NSArray *seqTail = [sequences subarrayWithRange:NSMakeRange(1, [sequences count]-1)];
    
    id <XPSequenceEnumeration>seqEnm = [seqExpr enumerateInContext:ctx sorted:NO];

    while ([seqEnm hasMoreItems]) {
        id <XPItem>inItem = [seqEnm nextItem];
        [ctx setItem:inItem forVariable:varName];

        if ([varNameTail count]) {
            [self loopInContext:ctx varNames:varNameTail sequences:seqTail];
        } else {
            id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
            while ([bodyEnm hasMoreItems]) {
                id <XPItem>bodyItem = [bodyEnm nextItem];
                [_result addObject:bodyItem];
            }
        }

        //[ctx setItem:nil forVariable:varName];
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
