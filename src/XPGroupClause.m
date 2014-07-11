//
//  XPGroupClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import "XPGroupClause.h"

@implementation XPGroupClause

+ (instancetype)groupClauseWithVariableName:(NSString *)varName expression:(XPExpression *)expr {
    XPGroupClause *gc = [[[XPGroupClause alloc] init] autorelease];
    gc.variableName = varName;
    gc.expression = expr;
    return gc;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"group by $%@ := %@", _variableName, _expression];
}


- (void)dealloc {
    self.variableName = nil;
    self.expression = nil;
    [super dealloc];
}

@end
