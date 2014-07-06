//
//  XPIfExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import <Panthro/XPExpression.h>

@interface XPIfExpression : XPExpression

- (instancetype)initWithTest:(XPExpression *)testExpr then:(XPExpression *)thenExpr else:(XPExpression *)elseExpr;
@end
