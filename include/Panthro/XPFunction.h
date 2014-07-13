//
//  XPFunction.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Panthro/XPExpression.h>
#import <Panthro/XPCallable.h>

@interface XPFunction : XPExpression <XPCallable>
+ (NSString *)name;
@end
