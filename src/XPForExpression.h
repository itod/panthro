//
//  XPForExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPExpression.h>

@interface XPForExpression : XPExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses body:(XPExpression *)bodyExpr;
@end
