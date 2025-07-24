//
//  FNReverse.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNReverse.h"
#import <Panthro/XPValue.h>
#import "XPNumericValue.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceValue.h"
#import "XPEmptySequence.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNReverse

+ (NSString *)name {
    return @"reverse";
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) {
        result = [self evaluateAsSequenceInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *val = [self evaluateAsSequenceInContext:ctx];
    return val;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = [XPEmptySequence instance];
    
    XPValue *seq = [self.args[0] evaluateInContext:ctx];

    if (seq != [XPEmptySequence instance]) {
        NSMutableArray *fwd = [NSMutableArray array];
        
        id <XPSequenceEnumeration>enm = [seq enumerateInContext:ctx sorted:YES];
        while ([enm hasMoreItems]) {
            id <XPItem>item = [enm nextItem];
            [fwd addObject:item];
        }
        
        NSUInteger c = [fwd count];
        if (c) {
            NSMutableArray *rev = [NSMutableArray arrayWithCapacity:c];
            for (id obj in [fwd reverseObjectEnumerator]) {
                [rev addObject:obj];
            }
            
            result = [[[XPSequenceExtent alloc] initWithContent:rev] autorelease];
        }
    }

    result.range = self.range;
    return result;
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNReverse *f = [[[FNReverse alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
