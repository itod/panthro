//
//  XPForClause.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPForClause : NSObject

+ (instancetype)forClauseWithVariableName:(NSString *)varName positionName:(NSString *)posName expression:(XPExpression *)collExpr;

@property (nonatomic, retain) NSString *variableName;
@property (nonatomic, retain) NSString *positionName;
@property (nonatomic, retain) XPExpression *expression;
@end
