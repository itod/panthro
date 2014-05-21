//
//  FNLast.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNLast.h"
#import "XPContext.h"
#import "XPValue.h"
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
    double res = [self evaluateAsNumberInContext:ctx];
    return [XPNumericValue numericValueWithNumber:res];
}


- (XPDependencies)dependencies {
    return XPDependenciesLast;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *f = self;
    if (dep & XPDependenciesLast) {
        f = [XPNumericValue numericValueWithNumber:[ctx last]];
    }
    f.range = self.range;
    return f;
}

@end
