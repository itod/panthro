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

@interface XPExpression ()
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
        FNNormalizeSpace *f = [[[FNNormalizeSpace alloc] init] autorelease];
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
