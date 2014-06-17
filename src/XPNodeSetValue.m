//
//  XPNodeSetValue.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetValue.h"
#import "XPNodeOrderComparer.h"
#import "XPNodeInfo.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "XPObjectValue.h"
#import "XPNodeEnumeration.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPSingletonNodeSet.h"
#import "XPLocalOrderComparer.h"
#import "XPException.h"
#import "XPEGParser.h"

@interface XPNodeSetValue ()
@property (nonatomic, retain) NSMutableArray *value; // TODO
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, retain) NSDictionary *stringValues;
@property (nonatomic, assign, readwrite, getter=isSorted) BOOL sorted;
@property (nonatomic, assign, readwrite, getter=isReverseSorted) BOOL reverseSorted;
@end

@implementation XPNodeSetValue

- (instancetype)initWithNodes:(NSArray *)nodes comparer:(id <XPNodeOrderComparer>)comparer {
    self = [super init];
    if (self) {
        self.value = [[nodes mutableCopy] autorelease];
        self.count = [_value count];
        self.comparer = comparer ? comparer : [XPLocalOrderComparer instance];
        self.sorted = _count < 2;
        self.reverseSorted = _count < 2;
    }
    return self;
}


- (instancetype)initWithEnumeration:(id <XPNodeEnumeration>)enm comparer:(id <XPNodeOrderComparer>)comparer {
    self = [super init];
    if (self) {
        NSMutableArray *nodes = [NSMutableArray array];
        
        NSUInteger c = 0;
        for (id <XPNodeInfo>node in enm) {
            [nodes addObject:node];
            ++c;
        }
        
        self.value = nodes;
        self.count = c;
        self.comparer = comparer;
        self.sorted = enm.isSorted || c < 2;
        self.sorted = enm.isReverseSorted || c < 2;
    }
    return self;
}


- (void)dealloc {
    self.comparer = nil;
    self.value = nil;
    self.stringValues = nil;
    [super dealloc];
}


- (XPDataType)dataType {
    return XPDataTypeNodeSet;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (XPNodeSetValue *)evaluateAsNodeSetInContext:(XPContext *)ctx {
    [self sort];
    return self;
}


- (id <XPNodeEnumeration>)enumerate {
    XPAssert(_value);
    id <XPNodeEnumeration>enm = [[[XPNodeSetValueEnumeration alloc] initWithNodes:_value isSorted:_sorted] autorelease];
    return enm;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    if (yn) [self sort];
    return [self enumerate];
}


- (NSString *)asString {
    return [[self firstNode] stringValue];
}


- (double)asNumber {
    return [[XPStringValue stringValueWithString:[self asString]] asNumber];
}


- (BOOL)asBoolean {
    return [self count] > 0;
}


- (XPNodeSetValue *)sort {
    if (_count < 2) self.sorted = YES;
    if (_sorted) return self;
    
    if (_reverseSorted) {
        
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[_value count]];
        for (id obj in [_value reverseObjectEnumerator]) {
            [nodes addObject:obj];
        }
        self.value = nodes;
        self.sorted = YES;
        self.reverseSorted = NO;
        
    } else {
        // sort the array
        
        XPQuickSort(self, 0, _count-1);
        
        // need to eliminate duplicate nodes. Note that we cannot compare the node
        // objects directly, because with attributes and namespaces there might be
        // two objects representing the same node.
        
        NSUInteger j = 1;
        for (NSUInteger i = 1; i < _count; i++) {
            if (![_value[i] isSameNodeInfo:_value[i-1]]) {
                _value[j++] = _value[i];
            }
        }
        
        if (_count - j > 0) {
            [_value removeObjectsInRange:NSMakeRange(j, _count-j)];
        }
        
        self.count = j;
        self.sorted = YES;
        self.reverseSorted = NO;
    }
    
    return self;
}


- (id <XPNodeInfo>)firstNode {
    id <XPNodeInfo>first = nil;
    id <XPNodeEnumeration>enm = [self enumerate];
    if ([enm hasMoreObjects]) {
        first = [enm nextObject];
    }
    return first;
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
    
    } else if ([other isNodeSetValue]) {
        
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
            
            id <XPNodeEnumeration>e2 = [(XPNodeSetValue *)other enumerate];
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
        
    } else if ([other isNodeSetValue]) {
        
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
            
            id <XPNodeEnumeration>e1 = [self enumerate];
            while ([e1 hasMoreObjects]) {
                NSString *s1 = [[e1 nextObject] stringValue];
                id <XPNodeEnumeration>e2 = [(XPNodeSetValue *)other enumerate];
                while ([e2 hasMoreObjects]) {
                    NSString *s2 = [[e2 nextObject] stringValue];
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
    
    if ([other isNodeSetValue]) {
        
        // find the min and max values in this nodeset
        
        double thismax = -INFINITY; //Double.NEGATIVE_INFINITY;
        double thismin = INFINITY; //Double.POSITIVE_INFINITY;
        BOOL thisIsEmpty = YES;
        
        id <XPNodeEnumeration>e1 = [self enumerate];
        while ([e1 hasMoreObjects]) {
            double val = XPNumberFromString([[e1 nextObject] stringValue]);
            if (val < thismin) thismin = val;
            if (val > thismax) thismax = val;
            thisIsEmpty = NO;
        }
        
        if (thisIsEmpty) return NO;
        
        // find the minimum and maximum values in the other nodeset
        
        double othermax = -INFINITY; //Double.NEGATIVE_INFINITY;
        double othermin = INFINITY; //Double.POSITIVE_INFINITY;
        BOOL otherIsEmpty = YES;
        
        id <XPNodeEnumeration>e2 = [(XPNodeSetValue *)other enumerate];
        while ([e2 hasMoreObjects]) {
            double val = XPNumberFromString([[e2 nextObject] stringValue]);
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
            id <XPNodeEnumeration>e1 = [self enumerate];
            while ([e1 hasMoreObjects]) {
                id <XPNodeInfo>node = [e1 nextObject];
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


#pragma mark -
#pragma mark XPSortable

/**
 * Compare two nodes in document sequence
 * (needed to implement the Sortable interface)
 */

- (NSComparisonResult)compare:(NSInteger)a to:(NSInteger)b {
    XPAssert(_comparer);
    return [_comparer compare:_value[a] to:_value[b]];
}

/**
 * Swap two nodes (needed to implement the Sortable interface)
 */

- (void)swap:(NSInteger)a with:(NSInteger)b {
    id <XPNodeInfo>temp = _value[a];
    _value[a] = _value[b];
    _value[b] = temp;
}

@end
