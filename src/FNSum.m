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
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;
    
    if ([arg0 isValue]) { // can't happen?
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    id <XPNodeEnumeration>e = [self.args[0] enumerateInContext:ctx sorted:NO];
    return [self total:e];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    return [XPNumericValue numericValueWithNumber:n];
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNSum *f = [[[FNSum alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
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
