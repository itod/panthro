//
//  XPFunction.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPExpression.h>

@interface XPFunction : XPExpression {
    NSMutableArray *args;
}

- (void)addArgument:(XPExpression *)expr;
- (NSUInteger)numberOfArguments;
- (NSString *)name;
@end
