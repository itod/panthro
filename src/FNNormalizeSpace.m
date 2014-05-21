//
//  FNNormalizeSpace.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNormalizeSpace.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPStringValue.h"
#import "XPNodeSetValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNNormalizeSpace

- (NSString *)normalize:(NSString *)str {
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    static NSRegularExpression *sRegex = nil;
    if (!sRegex) {
        sRegex = [[NSRegularExpression regularExpressionWithPattern:@"\\s+" options:0 error:nil] retain];
    }
    str = [sRegex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:@" "];
    
    return str;
}


+ (NSString *)name {
    return @"normalize-space";
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
    NSString *str = nil;
    if (1 == [self numberOfArguments]) {
        str = [self.args[0] evaluateAsStringInContext:ctx];
    } else {
        str = [ctx.contextNode stringValue];
    }
    str = [self normalize:str];
    return str;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (XPDependencies)dependencies {
    if (1 == [self numberOfArguments]) {
        return [(XPExpression *)self.args[0] dependencies];
    } else {
        return XPDependenciesContextNode;
    }
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        FNNormalizeSpace *f = [[[FNNormalizeSpace alloc] init] autorelease];
        [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
        f.staticContext = self.staticContext;
    f.range = self.range;
        return [f simplify];
    } else {
        if (dep & XPDependenciesContextNode) {
            return [self evaluateInContext:nil];
        } else {
            return self;
        }
    }
}

@end
