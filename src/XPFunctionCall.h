//
//  XPFunctionReference.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/XPExpression.h>
#import <Panthro/XPCallable.h>

@interface XPFunctionCall : XPExpression <XPCallable>

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithExpression:(XPExpression *)expr;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) XPExpression *expression;
@end
