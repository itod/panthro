//
//  XPBooleanValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanValue.h"

@implementation XPBooleanValue {
    BOOL _value;
}

+ (XPBooleanValue *)booleanValueWithBoolean:(BOOL)b {
    return [[[self alloc] initWithBoolean:b] autorelease];
}


- (instancetype)initWithBoolean:(BOOL)b {
    if (self = [super init]) {
        _value = b;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@()", [self asString]];
}


- (NSString *)asString {
    return _value ? @"true" : @"false";
}


- (double)asNumber {
    return _value ? 1.0 : 0.0;
}


- (BOOL)asBoolean {
    return _value;
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
