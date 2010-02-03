//
//  XPBooleanExpression.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPBinaryExpression.h>

@interface XPBooleanExpression : XPBinaryExpression {
    
}

+ (id)booleanExpression;

+ (id)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
