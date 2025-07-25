//
//  FNConcat.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNConcat.h"
#import <Panthro/XPValue.h>
#import "XPStringValue.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNConcat

+ (NSString *)name {
    return @"concat";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    [self checkArgumentCountForMin:2 max:NSIntegerMax];

    BOOL allKnown = YES;
    NSMutableArray *newArgs = [NSMutableArray arrayWithCapacity:[self.args count]];
    for (XPExpression *arg in self.args) {
        arg = [arg simplify];
        [newArgs addObject:arg];
        if (![arg isValue]) {
            allKnown = NO;
        }
    }
    
    self.args = newArgs;
    
    if (allKnown) {
        result = [self evaluateInContext:nil];
    }

    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSMutableString *ms = [NSMutableString string];
    
    for (XPExpression *arg in self.args) {
        [ms appendString:[arg evaluateAsStringInContext:ctx]];
    }
    
    return [[ms copy] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *str = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:str];
    val.range = self.range;
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
    FNConcat *f = [[[FNConcat alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    f.staticContext = self.staticContext;
    f.range = self.range;
    return [f simplify];
}

@end
