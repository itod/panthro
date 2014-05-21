//
//  FNPosition.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNPosition.h"
#import "XPContext.h"
#import "XPValue.h"
#import "XPNumericValue.h"

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNPosition

+ (NSString *)name {
    return @"position";
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:0 max:0];
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return (double)[ctx position];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double d = [self evaluateAsNumberInContext:ctx];
    XPValue *val = [XPNumericValue numericValueWithNumber:d];
    val.range = self.range;
    return val;
}


- (XPDependencies)dependencies {
    return XPDependenciesContextPosition;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    XPExpression *result = self;
    
    if (dep & XPDependenciesContextPosition) {
        result = [XPNumericValue numericValueWithNumber:[ctx position]];
    }
    
    result.range = self.range;
    return result;
}

@end
