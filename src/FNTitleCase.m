//
//  FNTitleCase.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNTitleCase.h"
#import "XPValue.h"
#import "XPStringValue.h"

@interface XPExpression ()
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNTitleCase

+ (NSString *)name {
    return @"title-case";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    XPExpression *result = self;
    
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    
    if (1 == numArgs) {
        id arg0 = [self.args[0] simplify];
        self.args[0] = arg0;
        
        if ([arg0 isValue]) {
            result = [self evaluateInContext:nil];
        }
    }
    
    result.range = self.range;
    return result;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s = [self.args[0] evaluateAsStringInContext:ctx];
    if ([s length]) {
        unichar c = toupper([s characterAtIndex:0]);
        s = [NSString stringWithFormat:@"%C%@", c, [s substringFromIndex:1]];
    }
    return s;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    NSString *str = [self evaluateAsStringInContext:ctx];
    XPValue *val = [XPStringValue stringValueWithString:str];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    XPDependencies dep = XPDependenciesContextNode;
    
    if (1 == [self numberOfArguments]) {
        dep = [(XPExpression *)self.args[0] dependencies];
    }

    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;
    
    if (1 == [self numberOfArguments]) {
        FNTitleCase *f = [[[FNTitleCase alloc] init] autorelease];
        [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
        f.staticContext = self.staticContext;
        f.range = self.range;
        result = [f simplify];
    } else if (dep & XPDependenciesContextNode) {
        result = [self evaluateInContext:nil];
        result.staticContext = self.staticContext;
        result.range = self.range;
    }
    
    return result;
}

@end
