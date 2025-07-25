//
//  FNDistinctValues.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNDistinctValues.h"
#import <Panthro/XPValue.h>
#import "XPAtomicSequence.h"
#import "XPEmptySequence.h"
#import "XPSequenceEnumeration.h"
#import "XPEGParser.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNDistinctValues

+ (NSString *)name {
    return @"distinct-values";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:2];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    BOOL isArg1Value = YES;
    
    // ignoring collation arg for now
    if ([self numberOfArguments] > 1) {
        id arg1 = [self.args[1] simplify];
        self.args[1] = arg1;
        
        isArg1Value = [arg1 isValue];
    }
    
    if ([arg0 isValue] && isArg1Value) {
        result = [self evaluateAsSequenceInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    id <XPItem>arg = [self.args[0] evaluateInContext:ctx];
    XPSequenceValue *seq = [self distinct:arg];
    seq.range = self.range;
    return seq;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
    return val;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNDistinctValues *f = [[[FNDistinctValues alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}


- (XPAtomicSequence *)distinct:(id <XPItem>)item {
    XPAtomicSequence *result = nil;
    
    item = XPAtomize(item);
    
    if ([item isKindOfClass:[XPEmptySequence class]]) {
        result = (XPEmptySequence *)item;
    } else {
//        NSMutableSet *set = [NSMutableSet set];
//        
//        id <XPSequenceEnumeration>enm = [item enumerate];
//        while ([enm hasMoreItems]) {
//            [set addObject:[enm nextItem]];
//        }
//        
//        result = [[[XPAtomicSequence alloc] initWithContent:[set allObjects]] autorelease];

        NSMutableArray *set = [NSMutableArray array];

        NSUInteger c = 0;
        id <XPSequenceEnumeration>enm = [item enumerate];
        while ([enm hasMoreItems]) {
            [set addObject:[enm nextItem]];
            c++;
        }
        
        [set sortUsingSelector:@selector(compareToValue:)];
        
        // need to eliminate duplicate nodes. Note that we cannot compare the node
        // objects directly, because with attributes and namespaces there might be
        // two objects representing the same node.
        
        NSUInteger j = 1;
        for (NSUInteger i = 1; i < c; i++) {
            if (![set[i] isEqualToValue:set[i-1]]) {
                set[j++] = set[i];
            }
        }
        
        if (c - j > 0) {
            [set removeObjectsInRange:NSMakeRange(j, c-j)];
        }
        
        result = [[[XPAtomicSequence alloc] initWithContent:set] autorelease];
    }
    
    return result;
}

@end
