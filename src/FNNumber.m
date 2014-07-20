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
    XPExpression *result = self;
    
    NSUInteger numArgs = [self checkArgumentCountForMin:0 max:1];
    if (1 == numArgs) {
        id arg0 = [self.args[0] simplify];
        self.args[0] = arg0;
        
        if (XPDataTypeNumber == [arg0 dataType]) {
            result = arg0;
        } else if ([arg0 isValue]) {
            result = [XPNumericValue numericValueWithNumber:[arg0 asNumber]];
        }
    }
    
    result.range = self.range;
    return result;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    if (1 == [self numberOfArguments]) {
        return [self.args[0] evaluateAsNumberInContext:ctx];
    } else {
        return XPNumberFromString([ctx.contextNode stringValue]);
    }
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double d = [self evaluateAsNumberInContext:ctx];
    XPValue *val = [XPNumericValue numericValueWithNumber:d];
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
        FNNumber *f = [[[FNNumber alloc] init] autorelease];
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
