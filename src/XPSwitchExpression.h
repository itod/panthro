//
//  XPSwitchExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPExpression.h>

@interface XPSwitchExpression : XPExpression

- (instancetype)initWithTest:(XPExpression *)testExpr defaultExpression:(XPExpression *)defaultExpr caseClauses:(NSArray *)caseClauses;
@end
