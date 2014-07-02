//
//  FNNormalizeUnicode.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNormalizeUnicode.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPStringValue.h"
#import "XPNodeSetValue.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNNormalizeUnicode

- (NSString *)normalize:(NSString *)str locale:(NSString *)localeName {
    NSLocale *locale = nil;
    if ([localeName length]) {
        locale = [NSLocale localeWithLocaleIdentifier:localeName];
        XPAssert(locale);
    }
    str = [str stringByFoldingWithOptions:NSLiteralSearch locale:locale];
    return str;
}


+ (NSString *)name {
    return @"normalize-unicode";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    NSUInteger numArgs = [self checkArgumentCountForMin:1 max:2];
    
    id input = [self.args[0] simplify];
    self.args[0] = input;
    
    id locale = nil;
    
    if (numArgs > 1) {
        locale = [self.args[1] simplify];
        self.args[1] = locale;

    }
    
    BOOL isLocaleValue = !locale || [locale isValue];
    
    if ([input isValue] && isLocaleValue) {
        result = [self evaluateInContext:nil];
    }

    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *input = [self.args[0] evaluateAsStringInContext:ctx];
    NSString *localeName = nil;
    if ([self numberOfArguments] > 1) {
        localeName = [self.args[1] evaluateAsStringInContext:ctx];
    }
    NSString *str = [self normalize:input locale:localeName];
    return str;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *str = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:str];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    if (1 == [self numberOfArguments]) {
        return [(XPExpression *)self.args[0] dependencies];
    } else {
        return XPDependenciesContextNode;
    }
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;
    
    if (1 == [self numberOfArguments]) {
        FNNormalizeUnicode *f = [[[FNNormalizeUnicode alloc] init] autorelease];
        [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
        f.staticContext = self.staticContext;
        f.range = self.range;
        result = [f simplify];
    } else if (dep & XPDependenciesContextNode) {
        result = [self evaluateInContext:nil];
    }
    
    result.range = self.range;
    return result;
}

@end
