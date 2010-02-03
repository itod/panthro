//
//  XPStringValue.h
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/XPValue.h>

@interface XPStringValue : XPValue {
    NSString *value;
}

+ (id)stringValueWithString:(NSString *)s;

- (id)initWithString:(NSString *)s;

- (BOOL)isEqualToStringValue:(XPStringValue *)v;

@end
