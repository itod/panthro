//
//  XPIfExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPIfExpression.h"
#import "XPContext.h"
#import "XPStaticContext.h"
#import "XPSequenceEnumeration.h"
#import "XPBooleanValue.h"

@interface XPIfExpression ()
@property (nonatomic, retain) XPExpression *testExpression;
@property (nonatomic, retain) XPExpression *thenExpression;
@property (nonatomic, retain) XPExpression *elseExpression;
@property (nonatomic, assign) BOOL result;
@end

@implementation XPIfExpression

- (instancetype)initWithTest:(XPExpression *)testExpr then:(XPExpression *)thenExpr else:(XPExpression *)elseExpr {
    XPAssert(testExpr);
    XPAssert(thenExpr);
    self = [super init];
    if (self) {
        self.testExpression = testExpr;
        self.thenExpression = thenExpr;
        self.elseExpression = elseExpr;
    }
    return self;
}


- (void)dealloc {
    self.testExpression = nil;
    self.thenExpression = nil;
    self.elseExpression = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPIfExpression *expr = [super copyWithZone:zone];
    expr.testExpression = [[_testExpression copy] autorelease];
    expr.thenExpression = [[_thenExpression copy] autorelease];
    expr.elseExpression = [[_elseExpression copy] autorelease];
    return expr;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPAssert(_testExpression);
    XPAssert(_thenExpression);
    
    BOOL test = [_testExpression evaluateAsBooleanInContext:ctx];
    
    XPValue *res = nil;
    
    if (test) {
        res = [_thenExpression evaluateInContext:ctx];
    } else if (_elseExpression) {
        res = [_elseExpression evaluateInContext:ctx];
    }
    
    return res;
}


- (XPDataType)dataType {
    return XPDataTypeAny;
}

@end
