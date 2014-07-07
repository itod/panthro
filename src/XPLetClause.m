//
//  XPLetClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import "XPLetClause.h"

@implementation XPLetClause

+ (instancetype)letClauseWithVariableName:(NSString *)varName expression:(XPExpression *)expr {
    XPLetClause *fc = [[[XPLetClause alloc] init] autorelease];
    fc.variableName = varName;
    fc.expression = expr;
    return fc;
}


- (void)dealloc {
    self.variableName = nil;
    self.expression = nil;
    [super dealloc];
}

@end
