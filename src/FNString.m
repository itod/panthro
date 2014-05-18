//
//  FNString.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNString.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPValue.h"
#import "XPStringValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNString

+ (NSString *)name {
    return @"string";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    NSUInteger num = [self checkArgumentCountForMin:0 max:1];
    
    if (1 == num) {
        id arg0 = [self.args[0] simplify];
        self.args[0] = arg0;
        
        if (XPDataTypeString == [arg0 dataType]) {
            return arg0;
        }
        if ([arg0 isValue]) {
            return [XPStringValue stringValueWithString:[arg0 asString]];
        }
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [self.args[0] evaluateAsStringInContext:ctx];
    } else {
        return [ctx.contextNode stringValue];
    }
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
        FNString *f = [[[FNString alloc] init] autorelease];
        [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
        [f setStaticContext:[self staticContext]];
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
