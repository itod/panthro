//
//  XPStringValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>

@interface XPStringValue : XPValue

+ (instancetype)stringValueWithString:(NSString *)s;

- (instancetype)initWithString:(NSString *)s;

- (BOOL)isEqualToStringValue:(XPStringValue *)v;

@end
