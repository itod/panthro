//
//  XPNumericValue.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNumericValue.h"

@implementation XPNumericValue

+ (id)numericValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


+ (id)numericValueWithNumber:(double)n {
    return [[[self alloc] initWithNumber:n] autorelease];
}


- (id)initWithString:(NSString *)s {
    return [self initWithNumber:XPNumberFromString(s)];
}


- (id)initWithNumber:(double)n {
    if (self = [super init]) {
        value = n;
    }
    return self;
}


- (NSString *)asString {
    // TODO
    return [[NSNumber numberWithDouble:value] stringValue];
}


- (double)asNumber {
    return value;
}


- (BOOL)asBoolean {
    return (value != 0.0 && !isnan(value));
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@number (%@)", [self indent:level], [self asString]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPNumericValue %p %@>", self, [self asString]];
}

@end
