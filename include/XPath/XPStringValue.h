//
//  XPStringValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/XPValue.h>

@interface XPStringValue : XPValue

+ (XPStringValue *)stringValueWithString:(NSString *)s;

- (id)initWithString:(NSString *)s;

- (BOOL)isEqualToStringValue:(XPStringValue *)v;

@end
