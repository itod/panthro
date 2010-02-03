//
//  FNSubstring.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNSubstring.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPStringValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNSubstring

- (NSString *)name {
    return @"substring";
}


- (NSInteger)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:2 max:3];

    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];

    id arg1 = [[args objectAtIndex:1] simplify];
    [args replaceObjectAtIndex:1 withObject:arg1];
    
    BOOL fixed = [arg0 isValue] && [arg1 isValue];
    if (3 == numArgs) {
        id arg2 = [[args objectAtIndex:2] simplify];
        [args replaceObjectAtIndex:2 withObject:arg2];

        fixed = fixed && [arg2 isValue];
    }
    if (fixed) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s = [[args objectAtIndex:0] evaluateAsStringInContext:ctx];
    double offset = [[args objectAtIndex:1] evaluateAsNumberInContext:ctx];
    offset -= 1.0; // XPath is 1-indexed

    if (2 == [self numberOfArguments]) {
        return [s substringFromIndex:offset];
    } else {
        double len = [[args objectAtIndex:2] evaluateAsNumberInContext:ctx];
        return [s substringWithRange:NSMakeRange(offset, len)];
    }
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
    FNSubstring *f = [[[FNSubstring alloc] init] autorelease];
    for (XPExpression *arg in args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
