//
//  FNInsertBefore.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNInsertBefore.h"
#import "XPValue.h"
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

@implementation FNInsertBefore

+ (NSString *)name {
    return @"insert-before";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:3 max:3];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    id arg2 = [self.args[2] simplify];
    self.args[2] = arg2;

    if ([arg0 isValue] && [arg1 isValue] && [arg2 isValue]) {
        result = [self evaluateAsSequenceInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = nil;

    XPSequenceValue *target = [self.args[0] evaluateAsSequenceInContext:ctx];
    XPSequenceValue *inserts = [self.args[2] evaluateAsSequenceInContext:ctx];

    NSUInteger targetLen = [target count];
    NSUInteger insertsLen = [inserts count];
    
    // If $target is the empty sequence, $inserts is returned. If $inserts is the empty sequence, $target is returned.
    if (0 == targetLen) {
        XPAssert([XPEmptySequence instance] == target);
        result = inserts;
    } else if (0 == insertsLen) {
        XPAssert([XPEmptySequence instance] == inserts);
        result = target;
    } else {
        // If $position is less than one (1), the first position, the effective value of $position is one (1).
        // If $position is greater than the number of items in $target, then the effective value of $position is equal to the number of items in $target plus 1.
        double d = [self.args[1] evaluateAsNumberInContext:ctx];

        NSUInteger insertIdx;
        if (d < 1) {
            insertIdx = 1;
        } else if (d > targetLen) {
            insertIdx = targetLen + 1;
        } else {
            insertIdx = d;
        }
        
        NSUInteger totalLen = targetLen + insertsLen;
        XPAssert(totalLen > 0);
        
        NSMutableArray *content = [NSMutableArray arrayWithCapacity:totalLen];

        NSUInteger j = 1;
        id <XPSequenceEnumeration>targetEnm = [target enumerate];
        while ([targetEnm hasMoreItems]) {
            if (insertIdx == j) {
                id <XPSequenceEnumeration>insertsEnm = [inserts enumerate];
                while ([insertsEnm hasMoreItems]) {
                    [content addObject:[insertsEnm nextItem]];
                }
            }
            [content addObject:[targetEnm nextItem]];
            ++j;
        }
        
        result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
    }

    XPAssert([result isKindOfClass:[XPSequenceValue class]]);
    result.range = self.range;
    return result;
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
    FNInsertBefore *f = [[[FNInsertBefore alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
