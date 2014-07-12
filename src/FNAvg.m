//
//  FNAvg.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNAvg.h"
#import "XPValue.h"
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

@implementation FNAvg

+ (NSString *)name {
    return @"avg";
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
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPSequenceValue *result = nil;
    
    id <XPSequenceEnumeration>enm = [self.args[0] enumerateInContext:ctx sorted:YES];
    BOOL isEmpty = ![enm hasMoreItems];
    
    if (isEmpty) {
        result = [XPEmptySequence instance];
    } else {
        double min = INFINITY;
        do {
            double d = [XPAtomize([enm nextItem]) asNumber];
            if (isnan(d)) {
                min = d;
                break;
            } else {
                min = MIN(min, d);
            }
        } while ([enm hasMoreItems]);
        XPNumericValue *num = [XPNumericValue numericValueWithNumber:min];
        result = [[[XPSequenceExtent alloc] initWithContent:@[num]] autorelease];
    }
    
    result.range = self.range;
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    XPValue *result = [self evaluateAsSequenceInContext:ctx];
    return result;
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNAvg *f = [[[FNAvg alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
