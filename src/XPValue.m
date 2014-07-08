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
#import "XPSequenceValue.h"
#import "XPObjectValue.h"
#import "XPAtomicSequence.h"
#import "XPEmptySequence.h"
#import "XPSequenceEnumeration.h"
#import "XPEGParser.h"

XPValue *XPAtomize(id <XPItem>inItem) {
    XPValue *result = nil;
    
    if ([inItem isAtomized]) {
        result = (XPValue *)inItem;
    } else if ([inItem isKindOfClass:[XPSequenceValue class]]) {
        NSMutableArray *v = nil;

        id <XPSequenceEnumeration>enm = [inItem enumerate];
        
        if ([enm hasMoreItems]) {
            v = [NSMutableArray array];
            while ([enm hasMoreItems]) {
                id <XPItem>currItem = [enm nextItem];
                
                if ([currItem isAtomized]) {
                    [v addObject:currItem];
                } else {
                    // atomize the node
                    assert([currItem conformsToProtocol:@protocol(XPNodeInfo)]);
                    // don't have to recurse here, as sequences cannot nest
                    [v addObject:[XPStringValue stringValueWithString:[currItem stringValue]]];
                }
            }
            
            assert([v count]);
            result = [[[XPAtomicSequence alloc] initWithContent:v] autorelease];
        } else {
            result = [XPEmptySequence instance];
        }
        
    } else {
        assert([inItem conformsToProtocol:@protocol(XPNodeInfo)]);
        result = [XPStringValue stringValueWithString:[inItem stringValue]];
    }
    
    return result;
}


double XPNumberFromString(NSString *s) {
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
#if 0

    double n;
    if ([s length]) {
        n = [s doubleValue];
    } else {
        n = NAN;
    }
    return n;
#else
//    if ([s rangeOfString:@"+"].length ||
//        [s rangeOfString:@"e"].length ||
//        [s rangeOfString:@"E"].length) {
//        return NAN;
//    }
    
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


- (BOOL)isAtomized {
    return YES;
}


- (BOOL)isAtomic {
    return YES;
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


- (BOOL)isEqual:(id)other {
    if ([other isKindOfClass:[XPValue class]]) {
        return [self isEqualToValue:other];
    } else {
        return NO;
    }
}


- (BOOL)isNotEqualToValue:(XPValue *)other {

    // if this is a NodeSet value, the method will be handled by the NodeSetValue class
    if ([other isSequenceValue]) {
        return [other isNotEqualToValue:self];
    }
    
    return ![self isEqualToValue:other];
}


#ifdef COMPATABILITY_MODE
- (BOOL)isEqualToValue:(XPValue *)other {
    
    // if this is a NodeSet value, the method will be handled by the NodeSetValue class
    if ([other isSequenceValue]) {
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


- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {
    
    if (op == XPEG_TOKEN_KIND_EQUALS) return [self isEqualToValue:other];
    if (op == XPEG_TOKEN_KIND_NOT_EQUAL) return [self isNotEqualToValue:other];
    
    if ([other isSequenceValue]) {
        return [other compareToValue:self usingOperator:[self inverseOperator:op]];
    }
    
    return [self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:op];
}


- (NSComparisonResult)compareToValue:(XPValue *)other {
    XPAssert([other isKindOfClass:[XPValue class]]);
    
    NSComparisonResult res = NSOrderedSame;
    if ([self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:XPEG_TOKEN_KIND_LT_SYM]) {
        res = NSOrderedAscending;
    } else {
        res = NSOrderedDescending;
    }
    
    return res;
}

#else

- (BOOL)isEqualToValue:(XPValue *)other {
    
    // if this is a NodeSet value, the method will be handled by the NodeSetValue class
    if ([other isSequenceValue]) {
        return [other isEqualToValue:self];
    }
    
    if ([self isBooleanValue] || [other isBooleanValue]) {
        return [self asBoolean] == [other asBoolean];
    }
    
    if ([self isStringValue] || [other isStringValue]) {
        return [[self asString] isEqualToString:[other asString]];
    }

    return [self asNumber] == [other asNumber];
}


- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {
    
    if (op == XPEG_TOKEN_KIND_EQUALS) return [self isEqualToValue:other];
    if (op == XPEG_TOKEN_KIND_NOT_EQUAL) return [self isNotEqualToValue:other];
    
    if ([other isSequenceValue]) {
        return [other compareToValue:self usingOperator:[self inverseOperator:op]];
    }
    
    if ([self isStringValue] || [other isStringValue]) {
        return [self compareString:[self asString] toString:[other asString] usingOperator:op];
    }
    
    return [self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:op];
}


- (NSComparisonResult)compareToValue:(XPValue *)other {
    XPAssert([other isKindOfClass:[XPValue class]]);
    
    NSComparisonResult res = NSOrderedSame;
    
    if ([self isStringValue] || [other isStringValue]) {
        if ([self compareString:[self asString] toString:[other asString] usingOperator:XPEG_TOKEN_KIND_LT_SYM]) {
            res = NSOrderedAscending;
        } else {
            res = NSOrderedDescending;
        }
    } else {
        if ([self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:XPEG_TOKEN_KIND_LT_SYM]) {
            res = NSOrderedAscending;
        } else {
            res = NSOrderedDescending;
        }
    }
    
    return res;
}
#endif


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


- (BOOL)compareString:(NSString *)a toString:(NSString *)b usingOperator:(NSInteger)op {
    NSComparisonResult res = [a compare:b];
    switch (op) {
        case XPEG_TOKEN_KIND_LT_SYM:
            return NSOrderedAscending == res;
        case XPEG_TOKEN_KIND_LE_SYM:
            return NSOrderedAscending == res || NSOrderedSame == res;
        case XPEG_TOKEN_KIND_GT_SYM:
            return NSOrderedDescending;
        case XPEG_TOKEN_KIND_GE_SYM:
            return NSOrderedDescending == res || NSOrderedSame == res;
        default:
            return NO;
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


- (NSComparisonResult)compare:(id)other {
    if ([other isKindOfClass:[XPValue class]]) {
        return [self compareToValue:other];
    } else {
        XPAssert(0);
        return NSOrderedSame;
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


- (BOOL)isSequenceValue {
    return [self isKindOfClass:[XPSequenceValue class]];
}


- (BOOL)isObjectValue {
    return [self isKindOfClass:[XPObjectValue class]];
}

@end
