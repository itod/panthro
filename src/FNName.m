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
#import "XPStringValue.h"
#import "XPNodeSetValue.h"

@interface XPExpression ()
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
    }
    
    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    id <XPNodeInfo>node = nil;
    if (1 == [self numberOfArguments]) {
        XPNodeSetValue *nodeSet = [[self.args[0] evaluateAsNodeSetInContext:ctx] sort];
        node = [nodeSet firstNode];
    } else {
        node = ctx.contextNode;
    }
    return [node name];
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
        FNName *f = [[[FNName alloc] init] autorelease];
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
