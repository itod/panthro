//
//  XPOrderClause.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPOrderClause : NSObject

+ (instancetype)orderClauseExpression:(XPExpression *)expr modifier:(NSComparisonResult)mod;

@property (nonatomic, retain) XPExpression *expression;
@property (nonatomic, assign) NSComparisonResult modifier;
@end
