//
//  FNSubstringAfter.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNSubstringAfter.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPStringValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNSubstringAfter

- (NSString *)name {
    return @"substring-after";
}


- (NSInteger)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:2 max:2];
    
    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];
    
    id arg1 = [[args objectAtIndex:1] simplify];
    [args replaceObjectAtIndex:1 withObject:arg1];
    
    if ([arg0 isValue] && [arg1 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s0 = [[args objectAtIndex:0] evaluateAsStringInContext:ctx];
    NSString *s1 = [[args objectAtIndex:1] evaluateAsStringInContext:ctx];

    NSRange r = [s0 rangeOfString:s1];
    if (NSNotFound == r.location) return @"";
    
    return [s0 substringFromIndex:r.location + r.length];
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
    FNSubstringAfter *f = [[[FNSubstringAfter alloc] init] autorelease];
    for (XPExpression *arg in args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
