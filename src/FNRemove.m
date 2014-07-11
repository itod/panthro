//
//  FNRemove.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNRemove.h"
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

@implementation FNRemove

+ (NSString *)name {
    return @"remove";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:2 max:2];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;

    if ([arg0 isValue] && [arg1 isValue]) {
        result = [self evaluateAsSequenceInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = nil;

    XPSequenceValue *target = [self.args[0] evaluateAsSequenceInContext:ctx];

    NSUInteger targetLen = [target count];
    
    // If $target is the empty sequence, $inserts is returned. If $inserts is the empty sequence, $target is returned.
    if (0 == targetLen) {
        XPAssert([XPEmptySequence instance] == target);
        result = target;
    } else {
        // If $position is less than 1 or greater than the number of items in $target, $target is returned.
        // Otherwise, the value returned by the function consists of all items of $target whose index is less than $position,
        // followed by all items of $target whose index is greater than $position. If $target is the empty sequence, the empty sequence is returned.
        double d = [self.args[1] evaluateAsNumberInContext:ctx];

        NSUInteger removeIdx;
        if (d < 1 || d > targetLen) {
            result = target;
        } else {
            removeIdx = d;
            
            NSMutableArray *content = [NSMutableArray arrayWithCapacity:d];
            
            NSUInteger j = 1;
            id <XPSequenceEnumeration>targetEnm = [target enumerateInContext:ctx sorted:NO];
            while ([targetEnm hasMoreItems]) {
                id <XPItem>item = [targetEnm nextItem];
                if (removeIdx != j) {
                    [content addObject:item];
                }
                ++j;
            }
            
            if ([content count]) {
                result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
            } else {
                result = [XPEmptySequence instance];
            }
        }
        
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
    FNRemove *f = [[[FNRemove alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
