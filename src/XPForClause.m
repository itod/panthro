//
//  XPForClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import "XPForClause.h"

@interface XPForClause ()
@end

@implementation XPForClause

+ (instancetype)emptyForClause {
    XPForClause *fc = [[[XPForClause alloc] init] autorelease];
    return fc;
}


+ (instancetype)forClauseWithVariableName:(NSString *)varName positionName:(NSString *)posName expression:(XPExpression *)collExpr {
    XPForClause *fc = [[[XPForClause alloc] init] autorelease];
    fc.variableName = varName;
    fc.positionName = posName;
    fc.expression = collExpr;
    return fc;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"for $%@ at %@ in %@", _variableName, _positionName, _expression];
}


- (void)dealloc {
    self.variableName = nil;
    self.positionName = nil;
    self.expression = nil;
    self.letClauses = nil;
    [super dealloc];
}

@end
