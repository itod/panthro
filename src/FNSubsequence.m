//
//  FNSubsequence.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSubsequence.h"
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

@implementation FNSubsequence

+ (NSString *)name {
    return @"subsequence";
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

    XPSequenceValue *source = [self.args[0] evaluateAsSequenceInContext:ctx];

    NSUInteger srcLen = [source count];
    
    // If $target is the empty sequence, $inserts is returned. If $inserts is the empty sequence, $target is returned.
    if (0 == srcLen) {
        XPAssert([XPEmptySequence instance] == source);
        result = [XPEmptySequence instance];
    } else {
        // Returns the contiguous sequence of items in the value of $sourceSeq beginning at the position indicated by the value of $startingLoc and continuing for the number of items indicated by the value of $length.
        // If $sourceSeq is the empty sequence, the empty sequence is returned.
        // If $startingLoc is zero or negative, the subsequence includes items from the beginning of the $sourceSeq.
        // If $length is not specified, the subsequence includes items to the end of $sourceSeq.
        // If $length is greater than the number of items in the value of $sourceSeq following $startingLoc, the subsequence includes items to the end of $sourceSeq.
        // The first item of a sequence is located at position 1, not position 0.
        
        double d = [self.args[1] evaluateAsNumberInContext:ctx];
        NSUInteger loc = 1;
        if (d > 1) {
            loc = d;
        }
        
        NSUInteger len = srcLen;
        if ([self numberOfArguments] > 2) {
            double d = [self.args[2] evaluateAsNumberInContext:ctx];
            if (d < 1) {
                len = 0;
            } else {
                len = d;
            }
        }
        
        XPAssert(NSNotFound != loc);
        XPAssert(NSNotFound != len);
        XPAssert(loc > 0);

        if (loc > srcLen || len == 0) {
            result = [XPEmptySequence instance];
        } else {
            NSMutableArray *content = [NSMutableArray arrayWithCapacity:len];
            
            NSUInteger j = 1;
            id <XPSequenceEnumeration>enm = [source enumerateInContext:ctx sorted:NO];
            while ([enm hasMoreItems]) {
                id <XPItem>item = [enm nextItem];
                
                if (j >= loc && j < loc+len) {
                    [content addObject:item];
                }
                ++j;
            }
            
            result = [[[XPSequenceExtent alloc] initWithContent:content] autorelease];
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
    FNSubsequence *f = [[[FNSubsequence alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
