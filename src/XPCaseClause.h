//
//  XPCaseClause.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPCaseClause : NSObject

- (instancetype)initWithTest:(XPExpression *)testExpr body:(XPExpression *)bodyExpr;

@property (nonatomic, retain) XPExpression *testExpression;
@property (nonatomic, retain) XPExpression *bodyExpression;
@end
