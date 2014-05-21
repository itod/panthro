//
//  FNStringLength.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStringLength.h"
#import "XPNodeInfo.h"
#import "XPContext.h"
#import "XPValue.h"
#import "XPNumericValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNStringLength

+ (NSString *)name {
    return @"string-length";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    
    if (1 == numArgs) {
        id arg0 = [self.args[0] simplify];
        self.args[0] = arg0;
        
        if ([arg0 isValue]) {
            return [self evaluateInContext:nil];
        }
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [[self.args[0] evaluateAsStringInContext:ctx] length];
    } else {
        return [[ctx.contextNode stringValue] length];
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPNumericValue numericValueWithNumber:[self evaluateAsNumberInContext:ctx]];
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
        FNStringLength *f = [[[FNStringLength alloc] init] autorelease];
        [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
        f.staticContext = self.staticContext;
    f.range = self.range;
        return [f simplify];
    } else {
        if (dep & XPDependenciesContextNode) {
            return [self evaluateInContext:ctx];
        } else {
            return self;
        }
    }
}

@end
