//
//  FNSum.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSum.h"
#import "XPValue.h"
#import "XPNumericValue.h"
#import "XPSequenceValue.h"
#import "XPSequenceEnumeration.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNSum

+ (NSString *)name {
    return @"sum";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:1 max:2];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    BOOL isArg1Value = YES;
    
    if ([self numberOfArguments] > 1) {
        id arg1 = [self.args[1] simplify];
        self.args[1] = arg1;
    }
    
    if ([arg0 isValue] && isArg1Value) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    double result = 0.0;
    
    XPSequenceValue *seq = [self.args[0] evaluateAsSequenceInContext:ctx];
    if (0 == [seq count]) {
        if ([self numberOfArguments] > 1) {
            result = [self.args[1] evaluateAsNumberInContext:ctx];
        }
    } else {
        id <XPSequenceEnumeration>enm = [seq enumerateInContext:ctx sorted:NO];
        while ([enm hasMoreItems]) {
            result += XPNumberFromString([[enm nextItem] stringValue]);
        }
    }
    
    return result;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double d = [self evaluateAsNumberInContext:ctx];
    XPValue *val = [XPNumericValue numericValueWithNumber:d];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNSum *f = [[[FNSum alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
