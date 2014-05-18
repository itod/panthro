//
//  FNSubstring.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNSubstring.h"
#import "XPValue.h"
#import "XPStringValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNSubstring

+ (NSString *)name {
    return @"substring";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:2 max:3];

    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    id arg1 = [self.args[1] simplify];
    self.args[1] = arg1;
    
    BOOL fixed = [arg0 isValue] && [arg1 isValue];
    if (3 == numArgs) {
        id arg2 = [self.args[2] simplify];
        self.args[2] = arg2;

        fixed = fixed && [arg2 isValue];
    }
    if (fixed) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s = [self.args[0] evaluateAsStringInContext:ctx];
    double offset = [self.args[1] evaluateAsNumberInContext:ctx];
    offset -= 1.0; // XPath is 1-indexed

    if (2 == [self numberOfArguments]) {
        return [s substringFromIndex:offset];
    } else {
        double len = [self.args[2] evaluateAsNumberInContext:ctx];
        return [s substringWithRange:NSMakeRange(offset, len)];
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    FNSubstring *f = [[[FNSubstring alloc] init] autorelease];
    for (XPExpression *arg in self.args) {
        [f addArgument:[arg reduceDependencies:dep inContext:ctx]];
    }
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
