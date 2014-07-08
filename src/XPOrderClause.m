//
//  XPOrderClause.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import "XPOrderClause.h"

@implementation XPOrderClause

+ (instancetype)orderClauseExpression:(XPExpression *)expr modifier:(NSComparisonResult)mod {
    XPOrderClause *oc = [[[XPOrderClause alloc] init] autorelease];
    oc.expression = expr;
    oc.modifier = mod;
    return oc;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"order by %@ %ld", _expression, _modifier];
}


- (void)dealloc {
    self.expression = nil;
    [super dealloc];
}

@end
