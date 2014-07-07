//
//  XPLetClause.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPLetClause : NSObject

+ (instancetype)letClauseWithVariableName:(NSString *)varName expression:(XPExpression *)expr;

@property (nonatomic, retain) NSString *variableName;
@property (nonatomic, retain) XPExpression *expression;
@end
