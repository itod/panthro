//
//  FNLast.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNLast.h"
#import "XPContext.h"
#import <Panthro/XPValue.h>
#import "XPNumericValue.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNLast

+ (NSString *)name {
    return @"last";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:0 max:0];
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return (double)[ctx last];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double d = [self evaluateAsNumberInContext:ctx];
    XPValue *val = [XPNumericValue numericValueWithNumber:d];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    return XPDependenciesLast;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *f = self;
    if (dep & XPDependenciesLast) {
        f = [XPNumericValue numericValueWithNumber:[ctx last]];
        f.range = self.range;
    }
    return f;
}

@end
