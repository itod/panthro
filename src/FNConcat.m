//
//  FNConcat.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNConcat.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPStringValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@property (nonatomic, retain) NSMutableArray *args;
@end

@implementation FNConcat

- (NSString *)name {
    return @"concat";
}


- (NSInteger)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:2 max:NSIntegerMax];
    BOOL allKnown = YES;
    NSMutableArray *newArgs = [NSMutableArray arrayWithCapacity:[args count]];
    for (XPExpression *arg in args) {
        arg = [arg simplify];
        [newArgs addObject:arg];
        if (![arg isValue]) {
            allKnown = NO;
        }
    }
    
    self.args = newArgs;
    
    if (allKnown) {
        return [self evaluateInContext:nil];
    }

    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSMutableString *ms = [NSMutableString string];
    
    for (XPExpression *arg in args) {
        [ms appendString:[arg evaluateAsStringInContext:ctx]];
    }
    
    return [[ms copy] autorelease];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (NSUInteger)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNConcat *f = [[[FNConcat alloc] init] autorelease];
    for (XPExpression *arg in args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
