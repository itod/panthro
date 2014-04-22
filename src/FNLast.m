//
//  FNLast.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <XPath/FNLast.h>
#import <XPath/XPContext.h>
#import <XPath/XPValue.h>
#import <XPath/XPNumericValue.h>

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNLast

- (NSString *)name {
    return @"last";
}


- (NSInteger)dataType {
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


- (NSUInteger)dependencies {
    return XPDependenciesLast;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (dep & XPDependenciesLast) {
        return [XPNumericValue numericValueWithNumber:[ctx last]];
    } else {
        return self;
    }
}

@end
