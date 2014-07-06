//
//  XPForExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPForExpression.h"
#import "XPContext.h"
#import "XPStaticContext.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceExtent.h"

@interface XPForExpression ()
@property (nonatomic, retain) NSArray *varNames;
@property (nonatomic, retain) NSArray *sequences;
@property (nonatomic, retain) XPExpression *bodyExpression;
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
    [super dealloc];
}



- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPAssert([_varNames count]);
    XPAssert([_sequences count]);
    XPAssert([_varNames count] == [_sequences count]);
    XPAssert(_bodyExpression);
    
    NSMutableArray *result = [NSMutableArray array];

    NSUInteger i = 0;
    for (NSString *varName in _varNames) {
        XPExpression *seqExpr = _sequences[i++];
        
        id <XPSequenceEnumeration>seqEnm = [seqExpr enumerateInContext:ctx sorted:NO];
        
        while ([seqEnm hasMoreItems]) {
            id <XPItem>inItem = [seqEnm nextItem];
            [ctx.staticContext setItem:inItem forVariable:varName];
            
            id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
            while ([bodyEnm hasMoreItems]) {
                id <XPItem>bodyItem = [bodyEnm nextItem];
                [result addObject:bodyItem];
            }
        }
    }
    
    XPValue *seq = [[[XPSequenceExtent alloc] initWithContent:result] autorelease];
    return seq;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
