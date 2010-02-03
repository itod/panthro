//
//  XPBooleanValue.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanValue.h"

@implementation XPBooleanValue

+ (id)booleanValueWithBoolean:(BOOL)b {
    return [[[self alloc] initWithBoolean:b] autorelease];
}


- (id)initWithBoolean:(BOOL)b {
    if (self = [super init]) {
        value = b;
    }
    return self;
}


- (NSString *)asString {
    return value ? @"true" : @"false";
}


- (double)asNumber {
    return value ? 1 : 0;
}


- (BOOL)asBoolean {
    return value;
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self asString]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPBooleanValue %@>", [self asString]];
}

@end
