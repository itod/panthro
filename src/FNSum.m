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
#import "XPNodeSetValue.h"
#import "XPNodeEnumeration.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@interface FNSum ()
- (double)total:(id <XPNodeEnumeration>)e;
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
    
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) { // can't happen?
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    id <XPNodeEnumeration>e = [self.args[0] enumerateInContext:ctx sorted:NO];
    return [self total:e];
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


- (double)total:(id <XPNodeEnumeration>)e {
    double sum = 0.0;
    for (id node in e) {
        sum += XPNumberFromString([node stringValue]);
    }
    return sum;
}

@end
