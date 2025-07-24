//
//  XPSwitchExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPSwitchExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPCaseClause.h"
#import <Panthro/XPValue.h>
#import "XPException.h"

@interface XPSwitchExpression ()
@property (nonatomic, retain) XPExpression *testExpression;
@property (nonatomic, retain) XPExpression *defaultExpression;
@property (nonatomic, retain) NSArray *caseClauses;
@end

@implementation XPSwitchExpression

- (instancetype)initWithTest:(XPExpression *)testExpr defaultExpression:(XPExpression *)defaultExpr caseClauses:(NSArray *)caseClauses; {
    XPAssert(testExpr);
    XPAssert(defaultExpr || [caseClauses count]);
    self = [super init];
    if (self) {
        self.testExpression = testExpr;
        self.defaultExpression = defaultExpr;
        self.caseClauses = caseClauses;
    }
    return self;
}


- (void)dealloc {
    self.testExpression = nil;
    self.defaultExpression = nil;
    self.caseClauses = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPSwitchExpression *expr = [super copyWithZone:zone];
    expr.testExpression = [[_testExpression copy] autorelease];
    expr.defaultExpression = [[_defaultExpression copy] autorelease];
    expr.caseClauses = [[_caseClauses copy] autorelease];
    return expr;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPAssert(_testExpression);
    XPAssert(_defaultExpression || [_caseClauses count]);
    
    XPValue *switchVal = [_testExpression evaluateInContext:ctx];
    
    XPValue *res = nil;
    
    BOOL matched = NO;
    for (XPCaseClause *caseClause in _caseClauses) {
        XPValue *testVal = [caseClause.testExpression evaluateInContext:ctx];
        
        if ([switchVal isEqualToValue:testVal]) {
            res = [caseClause.bodyExpression evaluateInContext:ctx];
            matched = YES;
            break;
        }
    }
    
    if (!matched) {
        if (_defaultExpression) {
            res = [_defaultExpression evaluateInContext:ctx];
        } else {
            [XPException raiseIn:self format:@"missing default case"];
        }
    }

    res.staticContext = self.staticContext;
    res.range = self.range;

    return res;
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}

@end
