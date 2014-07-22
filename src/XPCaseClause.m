//
//  XPCaseClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/14.
//
//

#import "XPCaseClause.h"

@implementation XPCaseClause

- (instancetype)initWithTest:(XPExpression *)testExpr body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.testExpression = testExpr;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.testExpression = nil;
    self.bodyExpression = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"case %@ return %@", _testExpression, _bodyExpression];
}

@end
