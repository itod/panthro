//
//  XPStringValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPStringValue.h"

@interface XPStringValue ()
@property (nonatomic, copy) NSString *value;
@end

@implementation XPStringValue

+ (XPStringValue *)stringValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (instancetype)initWithString:(NSString *)s {
    if (self = [super init]) {
        self.value = (!s ? @"" : s);
    }
    return self;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPStringValue *expr = [super copyWithZone:zone];
    expr.value = _value;
    return expr;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"'%@'", [self asString]];
}


- (NSString *)asString {
    return _value;
}


- (double)asNumber {
    return XPNumberFromString(_value);
}


- (BOOL)asBoolean {
    return [_value length] > 0;
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (BOOL)isEqualToStringValue:(XPStringValue *)v {
    return [_value isEqualToString:v->_value];
}

@end
