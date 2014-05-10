//
//  XPFunction.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPFunction : XPExpression

- (void)addArgument:(XPExpression *)expr;
- (NSUInteger)numberOfArguments;
- (NSString *)name;
@end
