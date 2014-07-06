//
//  XPQuantifiedExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPExpression.h>

@interface XPQuantifiedExpression : XPExpression

- (instancetype)initWithEvery:(BOOL)isEvery varNames:(NSArray *)varNames sequences:(NSArray *)sequences body:(XPExpression *)bodyExpr;
@end
