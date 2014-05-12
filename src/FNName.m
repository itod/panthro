//
//  FNName.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNName.h"
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

@implementation FNName

+ (NSString *)name {
    return @"name";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    
    if (1 == numArgs) {
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
        return [ctx.contextNode name];
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


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        FNName *f = [[[FNName alloc] init] autorelease];
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
