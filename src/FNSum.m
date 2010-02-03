//
//  FNSum.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNSum.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPNumericValue.h>
#import <Exedore/XPNodeSetValue.h>
#import <Exedore/XPNodeEnumerator.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@interface FNSum ()
- (double)total:(XPNodeEnumerator *)e;
@end

@implementation FNSum

- (NSString *)name {
    return @"sum";
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];
    
    if ([arg0 isValue]) { // can't happen?
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    XPNodeEnumerator *e = [[args objectAtIndex:0] enumerateInContext:ctx sorted:NO];
    return [self total:e];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    return [XPNumericValue numericValueWithNumber:n];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)[args objectAtIndex:0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNSum *f = [[[FNSum alloc] init] autorelease];
    [f addArgument:[[args objectAtIndex:0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}


- (double)total:(XPNodeEnumerator *)e {
    double sum = 0.0;
    for (id node in e) {
        sum += XPNumberFromString([node stringValue]);
    }
    return sum;
}

@end
