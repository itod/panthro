//
//  XPNodeSetValue.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNodeSetValue.h"
#import <XPath/XPBooleanValue.h>
#import <XPath/XPNumericValue.h>
#import <XPath/XPStringValue.h>
#import <XPath/XPObjectValue.h>
#import <XPath/XPNodeEnumeration.h>
#import <XPath/XPEnumeration.h>

@interface XPNodeSetValue ()
@property (nonatomic, copy) NSArray *value; // TODO
@property (nonatomic, assign) BOOL isSorted;
@property (nonatomic, retain) NSDictionary *stringValues;
@end

@implementation XPNodeSetValue

- (instancetype)initWithNodes:(NSArray *)nodes {
    self = [super init];
    if (self) {
        self.value = nodes;
    }
    return self;
}


- (instancetype)initWithEnumeration:(id <XPNodeEnumeration>)enm {
    self = [super init];
    if (self) {
        NSMutableArray *nodes = [NSMutableArray array];
        
        id <XPNodeInfo>node = nil;
        while ([enm hasMoreObjects]) {
            node = [enm nextObject];
            [nodes addObject:node];
        }
        
        self.value = nodes;
        self.isSorted = enm.isSorted;
    }
    return self;
}


- (void)dealloc {
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
    id <XPNodeEnumeration>enm = [[[XPEnumeration alloc] initWithNodes:_value isSorted:_isSorted] autorelease];
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


- (NSUInteger)count {
    XPAssert(_value);
    return [_value count];
}


- (XPNodeSetValue *)sort {
    XPNodeSetValue *result = self;
    
    if (!_sorted) {
        XPAssert(_value);
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[_value count]];
        for (id obj in [_value reverseObjectEnumerator]) {
            [nodes addObject:obj];
        }
        result = [[[XPNodeSetValue alloc] initWithNodes:nodes] autorelease];
        result.isSorted = NO;
    }
    
    return result;
}


- (id)firstNode {
    XPAssert(_value);
    return [_value firstObject];
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

    if ([other isKindOfClass:[XPObjectValue class]]) {
        return NO;
    
    } else if ([other isNodeSetValue]) {
        
        // singleton node-set
        if (1 == [(XPNodeSetValue *)other count]) {
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

@end
