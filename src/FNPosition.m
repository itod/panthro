//
//  FNPosition.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNPosition.h>
#import <Exedore/XPContext.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPNumericValue.h>

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNPosition

- (NSString *)name {
    return @"position";
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:0 max:0];
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return (double)[ctx contextPosition];
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPNumericValue numericValueWithNumber:[self evaluateAsNumberInContext:ctx]];
}


- (NSUInteger)dependencies {
    return XPDependenciesContextPosition;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    if (dep & XPDependenciesContextPosition) {
        return [XPNumericValue numericValueWithNumber:[ctx contextPosition]];
    } else {
        return self;
    }
}

@end
