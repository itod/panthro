//
//  FNNumber.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNNumber.h"
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

@implementation FNNumber

+ (NSString *)name {
    return @"number";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    if (1 == numArgs) {
        id arg0 = [self.args[0] simplify];
        self.args[0] = arg0;
        
        if (XPDataTypeNumber == [arg0 dataType]) {
            return arg0;
        }
        
        if ([arg0 isValue]) {
            return [XPNumericValue numericValueWithNumber:[arg0 asNumber]];
        }
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [self.args[0] evaluateAsNumberInContext:ctx];
    } else {
        return XPNumberFromString([ctx.contextNode stringValue]);
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPNumericValue numericValueWithNumber:[self evaluateAsNumberInContext:ctx]];
}


- (XPDependencies)dependencies {
    return [(XPExpression *)self.args[0] dependencies];
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        FNNumber *f = [[[FNNumber alloc] init] autorelease];
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
