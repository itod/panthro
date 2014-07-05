//
//  XPValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "XPNodeSetValue.h"
#import "XPObjectValue.h"
#import "XPAtomicSequence.h"
#import "XPEGParser.h"

double XPNumberFromString(NSString *s) {
#if 1
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    double n;
    if ([s length]) {
        n = [s doubleValue];
    } else {
        n = NAN;
    }
    return n;
#else
    if ([s rangeOfString:@"+"].length ||
        [s rangeOfString:@"e"].length ||
        [s rangeOfString:@"E"].length) {
        return NAN;
    }
    
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSScanner *scanner = [NSScanner scannerWithString:s];
    double n = 0;
    if ([scanner scanDouble:&n]) {
        if (HUGE_VAL == n || -HUGE_VAL == n) {
            n = NAN;
        }
    } else {
        n = NAN;
    }
    
    return n;
#endif
}

@implementation XPValue

#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return self;
}


- (id <XPSequenceEnumeration>)enumerate {
    XPValue *seq = [[[XPAtomicSequence alloc] initWithContent:@[self]] autorelease];
    return [seq enumerate];
}


#pragma mark -
#pragma mark XPItem

- (NSString *)stringValue {
    return [self asString];
}


#pragma mark -
#pragma mark XPExpression

- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return self;
}


- (XPExpression *)simplify {
    return self;
}


- (XPDependencies)dependencies {
    return 0;
}


- (NSString *)asString {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (double)asNumber {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0.0;
}


- (BOOL)asBoolean {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isEqualToValue:(XPValue *)other {

    // if this is a NodeSet value, the method will be handled by the NodeSetValue class
    if ([other isNodeSetValue]) {
        return [other isEqualToValue:self];
    }
    
    if ([self isBooleanValue] || [other isBooleanValue]) {
        return [self asBoolean] == [other asBoolean];
    }
    
    if ([self isNumericValue] || [other isNumericValue]) {
        return [self asNumber] == [other asNumber];
    }
    
    return [[self asString] isEqualToString:[other asString]];
}


- (BOOL)isNotEqualToValue:(XPValue *)other {

    // if this is a NodeSet value, the method will be handled by the NodeSetValue class
    if ([other isNodeSetValue]) {
        return [other isNotEqualToValue:self];
    }
    
    return ![self isEqualToValue:other];
}


- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {

    if (op == XPEG_TOKEN_KIND_EQUALS) return [self isEqualToValue:other];
    if (op == XPEG_TOKEN_KIND_NOT_EQUAL) return [self isNotEqualToValue:other];
    
    if ([other isNodeSetValue]) {
        return [other compareToValue:self usingOperator:[self inverseOperator:op]];
    }
    
    return [self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:op];
}


- (NSInteger)inverseOperator:(NSInteger)op {
    switch (op) {
        case XPEG_TOKEN_KIND_LT_SYM:
            return XPEG_TOKEN_KIND_GT_SYM;
        case XPEG_TOKEN_KIND_LE_SYM:
            return XPEG_TOKEN_KIND_GE_SYM;
        case XPEG_TOKEN_KIND_GT_SYM:
            return XPEG_TOKEN_KIND_LT_SYM;
        case XPEG_TOKEN_KIND_GE_SYM:
            return XPEG_TOKEN_KIND_LE_SYM;
        default:
            return op;
    }
}


- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op {
    switch (op) {
        case XPEG_TOKEN_KIND_LT_SYM:
            return x < y;
        case XPEG_TOKEN_KIND_LE_SYM:
            return x <= y;
        case XPEG_TOKEN_KIND_GT_SYM:
            return x > y;
        case XPEG_TOKEN_KIND_GE_SYM:
            return x >= y;
        default:
            return NO;
    }
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    return self;
}


- (BOOL)isBooleanValue {
    return [self isKindOfClass:[XPBooleanValue class]];
}


- (BOOL)isNumericValue {
    return [self isKindOfClass:[XPNumericValue class]];
}


- (BOOL)isStringValue {
    return [self isKindOfClass:[XPStringValue class]];
}


- (BOOL)isNodeSetValue {
    return [self isKindOfClass:[XPNodeSetValue class]];
}


- (BOOL)isObjectValue {
    return [self isKindOfClass:[XPObjectValue class]];
}

@end
