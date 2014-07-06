//
//  XPQuantifiedExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPQuantifiedExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPBooleanValue.h"

@interface XPQuantifiedExpression ()
@property (nonatomic, assign) BOOL every;
@property (nonatomic, retain) NSArray *varNames;
@property (nonatomic, retain) NSArray *sequences;
@property (nonatomic, retain) XPExpression *bodyExpression;
@property (nonatomic, assign) BOOL result;
@end

@implementation XPQuantifiedExpression

- (instancetype)initWithEvery:(BOOL)isEvery varNames:(NSArray *)varNames sequences:(NSArray *)sequences body:(XPExpression *)bodyExpr {
    XPAssert([varNames count] == [sequences count]);
    self = [super init];
    if (self) {
        self.every = isEvery;
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
    [super dealloc];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:b];
    val.range = self.range;
    return val;
}


- (BOOL)evaluateAsBooleanInContext:(XPContext *)ctx {
    XPAssert([_varNames count]);
    XPAssert([_sequences count]);
    XPAssert([_varNames count] == [_sequences count]);
    XPAssert(_bodyExpression);
    
    BOOL start = _every ? YES : NO;
    self.result = start;
    
    [self loopInContext:ctx varNames:_varNames sequences:_sequences];
    
    return _result;
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

        BOOL stop = NO;

        if ([varNameTail count]) {
            [self loopInContext:ctx varNames:varNameTail sequences:seqTail];
        } else {
            BOOL yn = [_bodyExpression evaluateAsBooleanInContext:ctx];
            if (_every) {
                if (!yn) {
                    self.result = NO;
                    stop = YES;
                }
            } else {
                if (yn) {
                    self.result = YES;
                    stop = YES;
                }
            }
        }

        [ctx setItem:nil forVariable:varName];

        if (stop) break;
    }
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
