//
//  XPForClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import "XPForClause.h"

@implementation XPForClause

+ (instancetype)forClauseWithVariableName:(NSString *)varName positionName:(NSString *)posName sequenceExpression:(XPExpression *)seqExpr {
    XPForClause *fc = [[[XPForClause alloc] init] autorelease];
    fc.variableName = varName;
    fc.positionName = posName;
    fc.sequenceExpression = seqExpr;
    return fc;
}


- (void)dealloc {
    self.variableName = nil;
    self.positionName = nil;
    self.sequenceExpression = nil;
    [super dealloc];
}

@end
