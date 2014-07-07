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

+ (instancetype)forClauseWithVariableName:(NSString *)varName positionName:(NSString *)posName sequenceExpression:(XPExpression *)seqExpr;

@property (nonatomic, retain) NSString *variableName;
@property (nonatomic, retain) NSString *positionName;
@property (nonatomic, retain) XPExpression *sequenceExpression;
@end
