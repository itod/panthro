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

@interface XPNodeSetValue ()
@property (nonatomic, copy) NSArray *value; // TODO
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
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    if (yn) [self sort];
    return [self enumerate];
}


- (BOOL)isSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (void)setSorted:(BOOL)yn {
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


- (XPNodeSetValue *)sort {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id)firstNode {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
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
