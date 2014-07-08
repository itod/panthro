//
//  XPSequenceValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPSequenceValue.h"
#import "XPNodeInfo.h"
#import "XPNodeInfo.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "XPSequenceEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPException.h"
#import "XPEGParser.h"

@interface XPSequenceValue ()
@property (nonatomic, retain) NSDictionary *stringValues;
@end

@implementation XPSequenceValue

- (void)dealloc {
    self.stringValues = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPSequenceEnumeration>)enumerate {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


#pragma mark -
#pragma mark XPItem

- (BOOL)isAtomized {
    return NO;
}


- (BOOL)isAtomic {
    return NO;
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    if (yn) [self sort];
    return [self enumerate];
}


- (BOOL)isSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (void)setSorted:(BOOL)sorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (BOOL)isReverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (void)setReverseSorted:(BOOL)reverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSString *)asString {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (double)asNumber {
    return [[XPStringValue stringValueWithString:[self asString]] asNumber];
}


- (BOOL)asBoolean {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (NSUInteger)count {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (XPSequenceValue *)sort {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return self;
}


- (id <XPNodeInfo>)firstNode {
    id <XPItem>item = [self head];
    if (![item conformsToProtocol:@protocol(XPNodeInfo)]) {
        [XPException raiseIn:self format:@"Expected node value, found: %@", item];
    }
    return (id <XPNodeInfo>)item;
}


- (XPValue *)firstValue {
    id <XPItem>item = [self head];
    if (![item isKindOfClass:[XPValue class]]) {
        [XPException raiseIn:self format:@"Expected atomic value, found: %@", item];
    }
    return (XPValue *)item;
}


- (NSDictionary *)stringValues {
    if (!_stringValues) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        for (id node in [self enumerate]) {
            [d setObject:[NSNull null] forKey:[node stringValue]];
        }

        self.stringValues = [[d copy] autorelease];
    }
    return _stringValues;
}


- (BOOL)isEqualToValue:(XPValue *)other {

    if ([other isObjectValue]) {
        return NO;
    
    } else if ([other isSequenceValue]) {
        
        // singleton node-set
        if ([other isKindOfClass:[XPSingletonNodeSet class]]) {
        //if (1 == [(XPNodeSetValue *)other count]) {
            if ([other asBoolean]) {
                return [self isEqualToValue:[XPStringValue stringValueWithString:[other asString]]];
            } else {
                return NO;
            }
        } else {
            NSDictionary *table = [self stringValues];
            
            id <XPSequenceEnumeration>e2 = [(XPSequenceValue *)other enumerate];
            for (id node in e2) {
                if ([table objectForKey:[node stringValue]]) return YES;
            }
            return NO;
        }

    } else if ([other isNumericValue]) {
        for (id node in [self enumerate]) {
            if (XPNumberFromString([node stringValue]) == [other asNumber]) return YES;
        }
        return NO;

    } else if ([other isStringValue]) {
        if (!_stringValues) {
            for (id node in [self enumerate]) {
                if ([[node stringValue] isEqualToString:[other asString]]) return YES;
            }
            return NO;
        } else {
            return nil != _stringValues[[other asString]];
        }

    } else if ([other isBooleanValue]) {
        return [self asBoolean] == [other asBoolean];

    } else {
        [NSException raise:@"InternalXPathError" format:@"Unknown data type in a relational expression"];
    }
    
    return NO;
}


- (BOOL)isNotEqualToValue:(XPValue *)other {

    if ([other isObjectValue]) {
        return NO;
        
    } else if ([other isSequenceValue]) {
        
        // singleton node-set
        if ([other isKindOfClass:[XPSingletonNodeSet class]]) {
        //if (1 == [(XPNodeSetValue *)other count]) {
            if ([other asBoolean]) {
                return [self isNotEqualToValue:[XPStringValue stringValueWithString:[other asString]]];
            } else {
                return NO;
            }
        } else {
            
            // see if there is a node in A with a different string value as a node in B
            // use a nested loop: it will usually finish very quickly!
            
            id <XPSequenceEnumeration>e1 = [self enumerate];
            while ([e1 hasMoreItems]) {
                NSString *s1 = [[e1 nextItem] stringValue];
                id <XPSequenceEnumeration>e2 = [(XPSequenceValue *)other enumerate];
                while ([e2 hasMoreItems]) {
                    NSString *s2 = [[e2 nextItem] stringValue];
                    if (![s1 isEqualToString:s2]) return YES;
                }
            }
            return NO;

        }
        
    } else if ([other isNumericValue]) {
        for (id node in [self enumerate]) {
            if (XPNumberFromString([node stringValue]) != [other asNumber]) return YES;
        }
        return NO;
        
    } else if ([other isStringValue]) {
        if (!_stringValues) {
            for (id node in [self enumerate]) {
                if (![[node stringValue] isEqualToString:[other asString]]) return YES;
            }
            return NO;
        } else {
            return nil != _stringValues[[other asString]];
        }
        
    } else if ([other isBooleanValue]) {
        return [self asBoolean] != [other asBoolean];
        
    } else {
        [NSException raise:@"InternalXPathError" format:@"Unknown data type in a relational expression"];
    }
    
    return NO;
}


/**
 * Test how a nodeset compares to another Value under a relational comparison
 * @param operator The comparison operator, one of Tokenizer.LE, Tokenizer.LT,
 * Tokenizer.GE, Tokenizer.GT,
 */

- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {
    if ([other isObjectValue]) {
        return NO;
    }
    
    if ([other isKindOfClass:[XPSingletonNodeSet class]]) {
        if ([other asBoolean]) {
            other = [XPStringValue stringValueWithString:[other asString]];
        } else {
            return NO;
        }
    }
    
    if (op == XPEG_TOKEN_KIND_EQUALS) return [self isEqualToValue:other];
    if (op == XPEG_TOKEN_KIND_NOT_EQUAL) return [self isNotEqualToValue:other];
    
    if ([other isSequenceValue]) {
        
        // find the min and max values in this nodeset
        
        double thismax = -INFINITY; //Double.NEGATIVE_INFINITY;
        double thismin = INFINITY; //Double.POSITIVE_INFINITY;
        BOOL thisIsEmpty = YES;
        
        id <XPSequenceEnumeration>e1 = [self enumerate];
        while ([e1 hasMoreItems]) {
            double val = XPNumberFromString([[e1 nextItem] stringValue]);
            if (val < thismin) thismin = val;
            if (val > thismax) thismax = val;
            thisIsEmpty = NO;
        }
        
        if (thisIsEmpty) return NO;
        
        // find the minimum and maximum values in the other nodeset
        
        double othermax = -INFINITY; //Double.NEGATIVE_INFINITY;
        double othermin = INFINITY; //Double.POSITIVE_INFINITY;
        BOOL otherIsEmpty = YES;
        
        id <XPSequenceEnumeration>e2 = [(XPSequenceValue *)other enumerate];
        while ([e2 hasMoreItems]) {
            double val = XPNumberFromString([[e2 nextItem] stringValue]);
            if (val < othermin) othermin = val;
            if (val > othermax) othermax = val;
            otherIsEmpty = NO;
        }
        
        if (otherIsEmpty) return NO;
        
        switch(op) {
            case XPEG_TOKEN_KIND_LT_SYM:
                return thismin < othermax;
            case XPEG_TOKEN_KIND_LE_SYM:
                return thismin <= othermax;
            case XPEG_TOKEN_KIND_GT_SYM:
                return thismax > othermin;
            case XPEG_TOKEN_KIND_GE_SYM:
                return thismax >= othermin;
            default:
                return NO;
        }
        
    } else {
        if ([other isNumericValue] || [other isStringValue]) {
            id <XPSequenceEnumeration>e1 = [self enumerate];
            while ([e1 hasMoreItems]) {
                id <XPItem>node = [e1 nextItem];
                if ([self compareNumber:XPNumberFromString([node stringValue]) toNumber:[other asNumber] usingOperator:op]) {
                    return YES;
                }
            }
            return NO;
        } else if ([other isBooleanValue]) {
            return [self compareNumber:[[XPBooleanValue booleanValueWithBoolean:[self asBoolean]] asNumber]
                              toNumber:[[XPBooleanValue booleanValueWithBoolean:[other asBoolean]] asNumber]
                         usingOperator:op];
        } else {
            [XPException raiseIn:self format:@"Unknown data type in a relational expression"];
            return NO;
        }
    }
}

@end
