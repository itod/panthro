//
//  XPFunction.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPFunction : XPExpression
+ (NSString *)name;

- (void)addArgument:(XPExpression *)expr;
- (NSUInteger)numberOfArguments;
@end
