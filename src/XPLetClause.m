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
    XPLetClause *lc = [[[XPLetClause alloc] init] autorelease];
    lc.variableName = varName;
    lc.expression = expr;
    return lc;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"let $%@ := %@", _variableName, _expression];
}


- (void)dealloc {
    self.variableName = nil;
    self.expression = nil;
    [super dealloc];
}

@end
